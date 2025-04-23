// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConsultationContract {
    enum ConsultationStatus { Pending, Confirmed, Ongoing, Completed, Canceled }

    struct Consultation {
        uint id;
        address patient;
        address doctor;
        uint256 dateTime;
        ConsultationStatus status;
    }

    uint private consultationCounter;
    mapping(uint => Consultation) public consultations;
    mapping(address => uint[]) public patientConsultations;
    mapping(address => uint[]) public doctorConsultations;

    event ConsultationRequested(uint id, address indexed patient, address indexed doctor, uint256 dateTime);
    event ConsultationConfirmed(uint id);
    event ConsultationStarted(uint id);
    event ConsultationCompleted(uint id);
    event ConsultationCanceled(uint id);

    modifier onlyDoctor(uint _consultationId) {
        require(msg.sender == consultations[_consultationId].doctor, "Only the assigned doctor can do this.");
        _;
    }
    modifier onlyPatient(uint _consultationId) {
        require(msg.sender == consultations[_consultationId].patient, "Only the patient can do this.");
        _;
    }
    function bookConsultation(address _doctor, uint256 _dateTime) external {
        require(_doctor != address(0), "Invalid doctor address.");
        require(_dateTime > block.timestamp, "Invalid date.");


        consultations[consultationCounter] = Consultation(
            consultationCounter,
            msg.sender,
            _doctor,
            _dateTime,
            ConsultationStatus.Pending
        );
        consultationCounter++;

        patientConsultations[msg.sender].push(consultationCounter);
        doctorConsultations[_doctor].push(consultationCounter);

        emit ConsultationRequested(consultationCounter, msg.sender, _doctor, _dateTime);
    }
    function confirmConsultation(uint _consultationId) external onlyDoctor(_consultationId) {
        require(consultations[_consultationId].status == ConsultationStatus.Pending, "Consultation must be pending.");
        consultations[_consultationId].status = ConsultationStatus.Confirmed;
        emit ConsultationConfirmed(_consultationId);
    }
    function startConsultation(uint _consultationId) external onlyDoctor(_consultationId) {
        require(consultations[_consultationId].status == ConsultationStatus.Confirmed, "Consultation must be confirmed.");
        consultations[_consultationId].status = ConsultationStatus.Ongoing;
        emit ConsultationStarted(_consultationId);
    }
    function completeConsultation(uint _consultationId) external onlyDoctor(_consultationId) {
        require(consultations[_consultationId].status == ConsultationStatus.Ongoing, "Consultation must be ongoing.");
        consultations[_consultationId].status = ConsultationStatus.Completed;
        emit ConsultationCompleted(_consultationId);
    }
    function cancelConsultation(uint _consultationId) external {
        require(
            msg.sender == consultations[_consultationId].patient || msg.sender == consultations[_consultationId].doctor,
            "Only patient or doctor can cancel."
        );
        require(
            consultations[_consultationId].status == ConsultationStatus.Pending ||
            consultations[_consultationId].status == ConsultationStatus.Confirmed,
            "Consultation cannot be canceled at this stage."
        );

        consultations[_consultationId].status = ConsultationStatus.Canceled;
        emit ConsultationCanceled(_consultationId);
    }
    function getConsultation(uint _consultationId) external view returns (Consultation memory) {
        return consultations[_consultationId];
    }
}
