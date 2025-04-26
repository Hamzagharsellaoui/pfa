import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/card_widget.dart';
import '../widgets/gender_selector.dart'; // Assuming this widget exists

class DoctorBookingForm extends StatefulWidget {
  final Function(DateTime)? onDateSelected; // Callback for date selection
  final Function(TimeOfDay)? onTimeSelected; // Callback for time selection

  const DoctorBookingForm({
    super.key,
    this.onDateSelected,
    this.onTimeSelected,
  });

  @override
  _DoctorBookingFormState createState() => _DoctorBookingFormState();
}

class _DoctorBookingFormState extends State<DoctorBookingForm> {
  double height = 150, weight = 70;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController complaintController = TextEditingController();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      widget.onDateSelected?.call(picked); // Notify parent of the selected date
    }
  }

  void _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() => selectedTime = pickedTime);
      widget.onTimeSelected?.call(pickedTime); // Notify parent of the selected time
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your existing build method remains unchanged
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

                const SizedBox(width: 16),
                DoctorCard(
                  doctorName: "Dr. Tarek Frikha",
                  imageUrl: "assets/images/frikh-3379374-small.gif",
                  rating: 2,
                  distance: 100,
                ),


            const SizedBox(height: 24),
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
            _buildSlider('Height (cm)', height, 100, 200, (value) => setState(() => height = value)),
            const SizedBox(height: 8),
            _buildSlider('Weight (kg)', weight, 40, 150, (value) => setState(() => weight = value)),
            const SizedBox(height: 16),
            const Text("Appointment Date", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  selectedDate != null ? DateFormat.yMMMMd().format(selectedDate!) : "Select Date",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Appointment Time", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  selectedTime != null ? selectedTime!.format(context) : "Select Time",
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
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take Photo"),
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload"),
                  onPressed: () {},
                ),
              ],
            ),
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