import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:pfa_flutter/logic/auth/auth_bloc.dart';
import 'package:pfa_flutter/data/models/PrescriptionModel.dart';
import '../../../data/repositories/PrescriptionRepository.dart';
import '../../widgets/ProfileImageWidget.dart';

class PrescriptionFormScreen extends StatefulWidget {
  const PrescriptionFormScreen({Key? key}) : super(key: key);

  @override
  _PrescriptionFormScreenState createState() => _PrescriptionFormScreenState();
}

class _PrescriptionFormScreenState extends State<PrescriptionFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<Map<String, dynamic>> _medications = [
    {'name': '', 'dosage': '', 'instructions': ''},
  ];
  String? _doctorId;
  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _secondaryColor = Color(0xFF4B0082);
  static const Color _accentColor = Color(0xFFEDE7F6);

  @override
  void initState() {
    super.initState();
    _loadDoctorId();
  }

  Future<void> _loadDoctorId() async {
    final userId = await AuthBloc.getIdFromToken();
    setState(() {
      _doctorId = userId;
    });
  }

  void _addMedication() {
    setState(() {
      _medications.add({'name': '', 'dosage': '', 'instructions': ''});
    });
  }

  void _removeMedication(int index) {
    setState(() {
      if (_medications.length > 1) {
        _medications.removeAt(index);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final dateFormatter = DateFormat('yyyy-MM-dd');
      final patientDob = formData['patientDob'] is DateTime
          ? dateFormatter.format(formData['patientDob'] as DateTime)
          : formData['patientDob'].toString();

      final prescriptionData = PrescriptionData(
        clinicName: formData['clinicName'] as String,
        clinicAddress: formData['clinicAddress'] as String,
        clinicPhone: formData['clinicPhone'] as String,
        clinicEmail: formData['clinicEmail'] as String,
        patientName: formData['patientName'] as String,
        patientDob: patientDob,
        insuranceInfo: formData['insuranceInfo'] as String,
        medications: _medications
            .map((m) => Medication(
          name: m['name'] as String,
          dosage: m['dosage'] as String,
          instructions: m['instructions'] as String,
        ))
            .toList(),
        additionalInstructions: formData['additionalInstructions'] as String? ?? '',
        doctorName: formData['doctorName'] as String,
        doctorSpecialty: formData['doctorSpecialty'] as String,
        doctorLicense: formData['doctorLicense'] as String,
      );

      try {
        final success = await Prescriptionrepository().generatePrescription(prescriptionData);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Prescription downloaded successfully',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              backgroundColor: _primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              elevation: 6,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Failed to download prescription',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              elevation: 6,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            elevation: 6,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _accentColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        title: const Text(
          'Create Prescription',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: _doctorId == null
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Doctor Profile',
                child: Column(
                  children: [
                    Center(
                      child: ProfileImageWidget(
                        userId: "some_user_id", // Still required, but not used in this static version
                        radius: 60, // Match the radius from PrescriptionFormScreen
                        borderColor: const Color(0xFF7C3AED), // Match the _primaryColor
                        borderWidth: 3, // Match the border width
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<String?>(
                      future: AuthBloc.getUsernameFromToken(),
                      builder: (context, snapshot) {
                        final username = snapshot.data ?? 'Doctor';
                        return Column(
                          children: [
                            Text(
                              'Dr. $username',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dentist',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionCard(
                title: 'Clinic Information',
                child: Column(
                  children: [
                    _buildTextField(
                      name: 'clinicName',
                      label: 'Clinic Name',
                      initialValue: 'Healthy Life Clinic',
                      validator: FormBuilderValidators.required(errorText: 'Clinic name is required'),
                      icon: Icons.local_hospital,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      name: 'clinicAddress',
                      label: 'Clinic Address',
                      initialValue: '123 Wellness St., Health City, HC 12345',
                      validator: FormBuilderValidators.required(errorText: 'Clinic address is required'),
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      name: 'clinicPhone',
                      label: 'Clinic Phone',
                      initialValue: '123-456-7890',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Phone number is required'),
                        FormBuilderValidators.phoneNumber(errorText: 'Invalid phone number'),
                      ]),
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      name: 'clinicEmail',
                      label: 'Clinic Email',
                      initialValue: 'contact@healthylifeclinic.com',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Email is required'),
                        FormBuilderValidators.email(errorText: 'Invalid email'),
                      ]),
                      icon: Icons.email,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionCard(
                title: 'Patient Information',
                child: Column(
                  children: [
                    _buildTextField(
                      name: 'patientName',
                      label: 'Patient Name',
                      initialValue: 'John Doe',
                      validator: FormBuilderValidators.required(errorText: 'Patient name is required'),
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    FormBuilderDateTimePicker(
                      name: 'patientDob',
                      decoration: _buildInputDecoration(
                        label: 'Patient Date of Birth',
                        icon: Icons.calendar_today,
                      ),
                      inputType: InputType.date,
                      format: DateFormat('yyyy-MM-dd'),
                      validator: FormBuilderValidators.required(errorText: 'Date of birth is required'),
                      initialValue: DateTime(1985, 10, 20),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      name: 'insuranceInfo',
                      label: 'Insurance Info',
                      initialValue: 'ABC Insurance',
                      validator: FormBuilderValidators.required(errorText: 'Insurance info is required'),
                      icon: Icons.card_membership,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionCard(
                title: 'Medications',
                child: Column(
                  children: [
                    ..._medications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final med = entry.value;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Medication #${index + 1}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                                if (_medications.length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => _removeMedication(index),
                                    tooltip: 'Remove Medication',
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              name: 'medication_name_$index',
                              label: 'Medication Name',
                              initialValue: med['name'],
                              validator: FormBuilderValidators.required(errorText: 'Medication name is required'),
                              onChanged: (value) => med['name'] = value ?? '',
                              icon: Icons.medical_services,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              name: 'medication_dosage_$index',
                              label: 'Dosage',
                              initialValue: med['dosage'],
                              validator: FormBuilderValidators.required(errorText: 'Dosage is required'),
                              onChanged: (value) => med['dosage'] = value ?? '',
                              icon: Icons.local_pharmacy,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              name: 'medication_instructions_$index',
                              label: 'Instructions',
                              initialValue: med['instructions'],
                              validator: FormBuilderValidators.required(errorText: 'Instructions are required'),
                              onChanged: (value) => med['instructions'] = value ?? '',
                              icon: Icons.description,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor.withOpacity(0.1),
                          foregroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.add, size: 24),
                        label: const Text(
                          'Add Another Medication',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        onPressed: _addMedication,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionCard(
                title: 'Additional Information',
                child: _buildTextField(
                  name: 'additionalInstructions',
                  label: 'Additional Instructions',
                  initialValue: 'Avoid alcohol while taking medication.',
                  maxLines: 3,
                  icon: Icons.note_add,
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionCard(
                title: 'Doctor Information',
                child: Column(
                  children: [
                    _buildTextField(
                      name: 'doctorName',
                      label: 'Doctor Name',
                      initialValue: 'Dr. Jane Smith',
                      validator: FormBuilderValidators.required(errorText: 'Doctor name is required'),
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      name: 'doctorSpecialty',
                      label: 'Doctor Specialty',
                      initialValue: 'General Practitioner',
                      validator: FormBuilderValidators.required(errorText: 'Specialty is required'),
                      icon: Icons.medical_information,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      name: 'doctorLicense',
                      label: 'Doctor License',
                      initialValue: 'GP123456',
                      validator: FormBuilderValidators.required(errorText: 'License is required'),
                      icon: Icons.badge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: _primaryColor.withOpacity(0.4),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Download Prescription',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: icon != null
          ? Icon(
        icon,
        color: _primaryColor,
        size: 22,
      )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  Widget _buildTextField({
    required String name,
    required String label,
    String? initialValue,
    FormFieldValidator<String>? validator,
    ValueChanged<String?>? onChanged,
    IconData? icon,
    int maxLines = 1,
  }) {
    return FormBuilderTextField(
      name: name,
      decoration: _buildInputDecoration(label: label, icon: icon),
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16),
      cursorColor: _primaryColor,
    );
  }
}