// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract ConsultationContract {
    error InvalidDoctorAddress();
    error InvalidDateTime();
    error ConsultationMustBePending();
    error OnlyAssignedDoctor();
    error OnlyPatientOrDoctorCanCancel();
    error ConsultationCannotBeCanceled();
    error ConsultationMustBeConfirmed();
    error ConsultationMustBeOngoing();

    event ConsultationRequested(uint id, address indexed patient, address indexed doctor, uint256 dateTime, string description);
    event ConsultationConfirmed(uint id);
    event ConsultationStarted(uint id);
    event DiagnosisProvided(uint id, string diagnosis);
    event PrescriptionIssued(uint id, string prescription);
    event ConsultationCompleted(uint id);
    event ConsultationCanceled(uint id, string reason);

    enum ConsultationStatus { Pending, Confirmed, Ongoing, Completed, Canceled }

    struct Consultation {
        uint id;
        address patient;
        address doctor;
        uint256 dateTime;
        ConsultationStatus status;
        string description;
    }

    uint private consultationCounter;
    mapping(uint => Consultation) public consultations;
    mapping(address => uint[]) public patientConsultations;
    mapping(address => uint[]) public doctorConsultations;

    modifier onlyDoctor(uint _consultationId) {
        if (msg.sender != consultations[_consultationId].doctor) {
            revert OnlyAssignedDoctor();
        }
        _;
    }
    modifier onlyPatient(uint _consultationId) {
        require(msg.sender == consultations[_consultationId].patient, "Only the patient can do this.");
        _;
    }
    function bookConsultation(address _doctor, uint256 _dateTime, string memory _description) external returns (uint) {
        if (_doctor == address(0)) {
            revert InvalidDoctorAddress();
        }
        if (_dateTime <= block.timestamp) {
            revert InvalidDateTime();
        }

        consultations[consultationCounter] = Consultation(
            consultationCounter,
            msg.sender,
            _doctor,
            _dateTime,
            ConsultationStatus.Pending,
            _description
        );
        patientConsultations[msg.sender].push(consultationCounter);
        doctorConsultations[_doctor].push(consultationCounter);

        emit ConsultationRequested(consultationCounter, msg.sender, _doctor, _dateTime, _description);
        consultationCounter++;
        return consultationCounter - 1; // Return the new ID
    }
    function confirmConsultation(uint _consultationId) external onlyDoctor(_consultationId) {
        if (consultations[_consultationId].status != ConsultationStatus.Pending) {
            revert ConsultationMustBePending();
        }
        consultations[_consultationId].status = ConsultationStatus.Confirmed;
        emit ConsultationConfirmed(_consultationId);
    }
    function startConsultation(uint _consultationId) external onlyDoctor(_consultationId) {
        if (consultations[_consultationId].status != ConsultationStatus.Confirmed) {
            revert ConsultationMustBeConfirmed();
        }
        consultations[_consultationId].status = ConsultationStatus.Ongoing;
        emit ConsultationStarted(_consultationId);
    }
    function provideDiagnosis(uint _consultationId, string memory _diagnosis) external onlyDoctor(_consultationId) {
        require(consultations[_consultationId].status == ConsultationStatus.Ongoing, "Consultation must be ongoing.");
        emit DiagnosisProvided(_consultationId, _diagnosis);
        // Optionally update consultation struct with diagnosis
    }
    function issuePrescription(uint _consultationId, string memory _prescription) external onlyDoctor(_consultationId) {
        require(consultations[_consultationId].status == ConsultationStatus.Ongoing, "Consultation must be ongoing.");
        emit PrescriptionIssued(_consultationId, _prescription);
        // Optionally update consultation struct with prescription
    }
    function completeConsultation(uint _consultationId) external onlyDoctor(_consultationId) {
        if (consultations[_consultationId].status != ConsultationStatus.Ongoing) {
            revert ConsultationMustBeOngoing();
        }
        consultations[_consultationId].status = ConsultationStatus.Completed;
        emit ConsultationCompleted(_consultationId);
    }
    function cancelConsultation(uint _consultationId, string memory _reason) external {
        if (msg.sender != consultations[_consultationId].patient && msg.sender != consultations[_consultationId].doctor) {
            revert OnlyPatientOrDoctorCanCancel();
        }
        if (consultations[_consultationId].status != ConsultationStatus.Pending && consultations[_consultationId].status != ConsultationStatus.Confirmed) {
            revert ConsultationCannotBeCanceled();
        }

        consultations[_consultationId].status = ConsultationStatus.Canceled;
        emit ConsultationCanceled(_consultationId, _reason);
    }
    function getConsultation(uint _consultationId) external view returns (Consultation memory) {
        return consultations[_consultationId];
    }
    function getPatientConsultationIds(address _patient) external view returns (uint[] memory) {
        return patientConsultations[_patient];
    }

    function getDoctorConsultationIds(address _doctor) external view returns (uint[] memory) {
        return doctorConsultations[_doctor];
    }
}