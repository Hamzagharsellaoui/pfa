import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  const GenderSelector({super.key});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: genderButton('Male')),
        const SizedBox(width: 16),
        Expanded(child: genderButton('Female')),
      ],
    );
  }

  Widget genderButton(String gender) {
    final bool isSelected = selectedGender == gender;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.purple : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Text(gender),
    );
  }
}
