import 'package:flutter/material.dart';
// import your custom widgets
import '../../../../pfa-master/lib/presentation/screens/DoctorDetailScreen.dart';
import '../../../../pfa-master/lib/presentation/screens/doctor_booking_form.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int currentStep = 0;

  void goToNextStep() {
    if (currentStep < 1) { // only allow step 0 -> step 1
      setState(() {
        currentStep++;
      });
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
        return DoctorBookingForm(); // Patient Details
      case 1:
        return DoctorDetailScreen(doctorId: 123); // Payment
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Pop until we get back to the root (main scaffold) screen
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BookingStepper(currentStep: currentStep),
            const SizedBox(height: 30),
            Expanded(child: getStepContent()), // step widget here
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

  BookingStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    List<String> titles = ['Patient Details', 'Payment']; // ✅ NEW
    List<IconData> icons = [Icons.person, Icons.payment]; // ✅ NEW

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
            SizedBox(height: 4),
            Text(
              titles[index],
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            )
          ],
        );
      }),
    );
  }
}