class PrescriptionData {
  final String clinicName;
  final String clinicAddress;
  final String clinicPhone;
  final String clinicEmail;
  final String patientName;
  final String patientDob;
  final String insuranceInfo;
  final List<Medication> medications;
  final String additionalInstructions;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorLicense;

  PrescriptionData({
    required this.clinicName,
    required this.clinicAddress,
    required this.clinicPhone,
    required this.clinicEmail,
    required this.patientName,
    required this.patientDob,
    required this.insuranceInfo,
    required this.medications,
    required this.additionalInstructions,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorLicense,
  });

  Map<String, dynamic> toJson() => {
    'clinicName': clinicName,
    'clinicAddress': clinicAddress,
    'clinicPhone': clinicPhone,
    'clinicEmail': clinicEmail,
    'patientName': patientName,
    'patientDob': patientDob,
    'insuranceInfo': insuranceInfo,
    'medications': medications.map((m) => m.toJson()).toList(),
    'additionalInstructions': additionalInstructions,
    'doctorName': doctorName,
    'doctorSpecialty': doctorSpecialty,
    'doctorLicense': doctorLicense,
  };
}

class Medication {
  final String name;
  final String dosage;
  final String instructions;

  Medication({
    required this.name,
    required this.dosage,
    required this.instructions,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'dosage': dosage,
    'instructions': instructions,
  };
}