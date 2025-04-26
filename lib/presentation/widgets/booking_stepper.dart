import 'package:flutter/material.dart';

class BookingStepper extends StatelessWidget {
  final int currentStep; // 0 = Patient Details, 1 = Payment

  BookingStepper({required this.currentStep});

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
