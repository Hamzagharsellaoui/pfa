import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/gender_selector.dart';  // Assuming this widget exists

class DoctorBookingForm extends StatefulWidget {
  const DoctorBookingForm({super.key});

  @override
  _DoctorBookingFormState createState() => _DoctorBookingFormState();
}

class _DoctorBookingFormState extends State<DoctorBookingForm> {
  double height = 150, weight = 70;
  DateTime? selectedDate;
  final TextEditingController complaintController = TextEditingController();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _goToNextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NextStepPage()), // Replace with actual next step page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Booking"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Doctor Info
            Row(
              children: [
                const CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Dr. Hannibel Lector", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("10km", style: TextStyle(color: Colors.grey)),
                    Row(
                      children: [Icon(Icons.star, color: Colors.orange, size: 16), SizedBox(width: 4), Text("8.1")],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),

            // Personal Bio Section
            const Text("Personal Bio", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField('Full Name', Icons.person),
            const SizedBox(height: 16),
            _buildTextField('Email', Icons.email),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', Icons.phone, keyboardType: TextInputType.phone),

            const SizedBox(height: 24),
            const Text("Physical Information", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const GenderSelector(),
            const SizedBox(height: 24),

            // Height & Weight Sliders
            _buildSlider('Height (cm)', height, 100, 200, (value) => setState(() => height = value)),
            const SizedBox(height: 8),
            _buildSlider('Weight (kg)', weight, 40, 150, (value) => setState(() => weight = value)),

            const SizedBox(height: 16),
            const Text("Date of Birth", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                child: Text(
                  selectedDate != null ? DateFormat.yMMMMd().format(selectedDate!) : "Select Date",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Additional Comments", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: complaintController,
              maxLength: 300,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Main Complaint",
                hintText: "My tummy hurts for no reason :(",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            const Text("Complaint Photo (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Please take a picture of your condition so the doctor can analyze it beforehand."),

            // Photo Buttons
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(icon: const Icon(Icons.camera_alt), label: const Text("Take Photo"), onPressed: () {}),
                const SizedBox(width: 16),
                ElevatedButton.icon(icon: const Icon(Icons.upload), label: const Text("Upload"), onPressed: () {}),
              ],
            ),

            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder()),
      keyboardType: keyboardType,
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.round().toString(),
          activeColor: Colors.purple,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class NextStepPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Step")),
      body: const Center(child: Text("This is the next step page")),
    );
  }
}
