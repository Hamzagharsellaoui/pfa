import 'package:flutter/material.dart';

class DoctorPrescriptionCreateScreen extends StatefulWidget {
  final String? patientId;

  const DoctorPrescriptionCreateScreen({super.key, this.patientId});

  @override
  State<DoctorPrescriptionCreateScreen> createState() => _DoctorPrescriptionCreateScreenState();
}

class _DoctorPrescriptionCreateScreenState extends State<DoctorPrescriptionCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicationController = TextEditingController();
  final _dosageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Prescription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (widget.patientId == null) _buildPatientSelector(),
              TextFormField(
                controller: _medicationController,
                decoration: const InputDecoration(labelText: 'Medication Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosage Instructions'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPrescription,
                child: const Text('Save Prescription'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSelector() => DropdownButtonFormField<String>(
    items: [], // Load patients from API
    decoration: const InputDecoration(labelText: 'Select Patient'),
    validator: (value) => value == null ? 'Required' : null,
    onChanged: (value) {},
  );

  void _submitPrescription() {
    if (_formKey.currentState!.validate()) {
      // Save to API
      Navigator.pop(context); // Return to previous screen
    }
  }
}