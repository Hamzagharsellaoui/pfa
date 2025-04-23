import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../data/tooth_decay_detector.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/auth/auth_event.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
    const doctorPrimaryColor = Color(0xFF7C3AED); // Medical purple

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildDoctorAppBar(context, currentDate, doctorPrimaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDoctorStatsGrid(doctorPrimaryColor),
            const SizedBox(height: 24),
            _buildQuickAccessPanel(context, doctorPrimaryColor),
            const SizedBox(height: 24),
            _buildPatientAppointmentsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: doctorPrimaryColor,
        child: const Icon(Icons.medical_services, color: Colors.white),
        onPressed: () => _showMedicalToolsDialog(context),
      ),
    );
  }

  PreferredSizeWidget _buildDoctorAppBar(
      BuildContext context, String currentDate, Color primaryColor) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 120,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: FutureBuilder<String?>(
          future: AuthBloc.getUsernameFromToken(),
          builder: (context, snapshot) {
            final username = snapshot.data ?? "Doctor";
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF7C3AED)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentDate,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text("Dr. $username",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        const SizedBox(height: 2),
                        const Row(
                          children: [
                            Icon(Icons.medical_services,
                                size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text("Dentist",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_active,
                          size: 26, color: Colors.white),
                      onPressed: () => _showDoctorAlerts(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout,
                          size: 26, color: Colors.white),
                      onPressed: () => _confirmLogout(context),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDoctorStatsGrid(Color primaryColor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          icon: Icons.calendar_today,
          title: "Today's Appointments",
          value: "12",
          color: primaryColor,
        ),
        _buildStatCard(
          icon: Icons.people_alt,
          title: "Active Patients",
          value: "42",
          color: Colors.teal,
        ),
        _buildStatCard(
          icon: Icons.medication,
          title: "Prescriptions",
          value: "8",
          color: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.assignment,
          title: "Medical Records",
          value: "36",
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessPanel(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Access",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickActionButton(
              icon: Icons.add_circle_outline,
              label: "New Patient",
              color: primaryColor,
              onPressed: () {},
            ),
            _buildQuickActionButton(
              icon: Icons.medical_services,
              label: "Treatment Plan",
              color: Colors.teal,
              onPressed: () {},
            ),
            _buildQuickActionButton(
              icon: Icons.description,
              label: "Reports",
              color: Colors.blue,
              onPressed: () {},
            ),
            _buildQuickActionButton(
              icon: Icons.bar_chart,
              label: "Statistics",
              color: Colors.orange,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Today's Appointments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () {},
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAppointmentItem(
                  patient: "Mohamed Ali",
                  time: "09:00 AM",
                  procedure: "Dental Checkup",
                  status: "Confirmed",
                ),
                const Divider(height: 24),
                _buildAppointmentItem(
                  patient: "Fatma Ben Ahmed",
                  time: "10:30 AM",
                  procedure: "Tooth Extraction",
                  status: "Confirmed",
                ),
                const Divider(height: 24),
                _buildAppointmentItem(
                  patient: "Ahmed Ben Salah",
                  time: "02:15 PM",
                  procedure: "Teeth Cleaning",
                  status: "Pending",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentItem({
    required String patient,
    required String time,
    required String procedure,
    required String status,
  }) {
    final isConfirmed = status == "Confirmed";
    final statusColor = isConfirmed ? Colors.green : Colors.orange;

    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(patient,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(procedure,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(status,
                  style: TextStyle(color: statusColor, fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  void _showMedicalToolsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.medical_services, color: Color(0xFF7C3AED)),
                  SizedBox(width: 12),
                  Text("Medical Tools",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Tooth Decay Check"),
                  onPressed: () => _showDiagnosisDialog(context),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.assignment),
                  label: const Text("Patient Records"),
                  onPressed: () => _accessMedicalRecords(context),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiagnosisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medical_services,
                    color: Color(0xFF7C3AED),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Tooth Decay Check",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Upload a clear photo of your tooth for AI-powered preliminary analysis.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.upload, size: 22),
                  label: const Text(
                    "Upload Photo",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => _pickAndAnalyzeImage(context),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showDoctorAlerts(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Medical Alerts"),
        content: const Text("No critical alerts at this time"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout from the medical system?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _accessMedicalRecords(BuildContext context) {
    Navigator.pop(context); // Close tools dialog first
    Navigator.pushNamed(context, '/medical-records');
  }
  Future<void> _pickAndAnalyzeImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF7C3AED)),
              const SizedBox(height: 20),
              Text(
                "Analyzing your tooth...",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final result = await GeminiService.analyzeToothImage(File(pickedFile.path));
      Navigator.pop(context); // Close loading dialog

      if (result == null) {
        throw Exception("Failed to analyze image");
      }

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Diagnosis Result"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Decay Percentage: ${result['decay_percentage'] ?? 'N/A'}"),
              const SizedBox(height: 8),
              Text("Recommendation: ${result['see_dentist'] ?? 'N/A'}"),
              const SizedBox(height: 8),
              Text("Explanation: ${result['explanation'] ?? 'No explanation'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString().replaceAll('Exception: ', '')}")),
      );
    }
  }
}
