import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final bool doctorMode;

  const NavbarWidget({
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.doctorMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(doctorMode ? Icons.medical_services : Icons.search),
          label: doctorMode ? 'Patients' : 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today),
          label: 'Schedule',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}