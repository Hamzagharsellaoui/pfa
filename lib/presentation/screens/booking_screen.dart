import 'package:flutter/material.dart';
import 'DoctorDetailScreen.dart';
import 'doctor_booking_form.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int currentStep = 0;
  DateTime? selectedDate; // Store selected date
  TimeOfDay? selectedTime; // Store selected time

  void goToNextStep() {
    if (currentStep < 1) {
      if (selectedDate != null && selectedTime != null) { // Validate before proceeding
        setState(() {
          currentStep++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both date and time')),
        );
      }
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Widget getStepContent() {
    switch (currentStep) {
      case 0:
        return DoctorBookingForm(
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
              print("BookingScreen: Selected Date = $date"); // Debug
            });
          },
          onTimeSelected: (time) {
            setState(() {
              selectedTime = time;
              print("BookingScreen: Selected Time = $time"); // Debug
            });
          },
        ); // Patient Details
      case 1:
        return DoctorDetailScreen(
          doctorId: 123, // Replace with actual doctor ID in a real app
          selectedDate: selectedDate!,
          selectedTime: selectedTime!,
        ); // Payment
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BookingStepper(currentStep: currentStep),
            const SizedBox(height: 30),
            Expanded(child: getStepContent()),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep > 0)
                  ElevatedButton.icon(
                    onPressed: goToPreviousStep,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                  )
                else
                  const SizedBox(width: 100),
                ElevatedButton(
                  onPressed: currentStep < 1 ? goToNextStep : null,
                  child: const Text("Continue"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookingStepper extends StatelessWidget {
  final int currentStep;

  const BookingStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    List<String> titles = ['Patient Details', 'Payment'];
    List<IconData> icons = [Icons.person, Icons.payment];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(2, (index) {
        bool isActive = index == currentStep;
        return Column(
          children: [
            Icon(
              icons[index],
              color: isActive ? Colors.blue : Colors.grey,
              size: isActive ? 30 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              titles[index],
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }
}