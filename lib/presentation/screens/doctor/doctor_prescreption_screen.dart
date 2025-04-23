import 'package:flutter/material.dart';

import '../../../core/routes.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  final String patientId; // Pass patient ID if coming from patient view

  const DoctorPrescriptionScreen({super.key, required this.patientId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
  // State<DoctorPrescriptionScreen> createState() => _DoctorPrescriptionScreenState();


// class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
//   // final List<Prescription> _prescriptions = []; // Load from API
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Prescriptions'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _navigateToCreatePrescription(),
//           ),
//         ],
//       ),
//       body: _prescriptions.isEmpty
//           ? _buildEmptyState()
//           : ListView.builder(
//         itemCount: _prescriptions.length,
//         itemBuilder: (context, index) => _buildPrescriptionCard(_prescriptions[index]),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Icon(Icons.medication, size: 64),
//         const SizedBox(height: 16),
//         const Text('No prescriptions yet'),
//         TextButton(
//           onPressed: _navigateToCreatePrescription,
//           child: const Text('Create First Prescription'),
//         ),
//       ],
//     ),
//   );
//
//   Widget _buildPrescriptionCard(Prescription prescription) => Card(
//     child: ListTile(
//       title: Text(prescription.medicationName),
//       subtitle: Text('For ${prescription.patientName}'),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: () => _viewPrescriptionDetails(prescription.id),
//     ),
//   );
//
//   void _navigateToCreatePrescription() {
//     Navigator.pushNamed(
//       context,
//       AppRoutes.doctorPrescriptionCreate,
//       arguments: widget.patientId, // Pass patient ID if available
//     );
//   }
//
//   void _viewPrescriptionDetails(String prescriptionId) {
//     Navigator.pushNamed(
//         context,
//         AppRoutes.doctorPrescriptionView,
//         arguments: prescriptionId
//     }
// }