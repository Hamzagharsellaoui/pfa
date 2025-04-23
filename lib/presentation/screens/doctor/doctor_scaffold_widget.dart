import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../navigation/NavigationCubit.dart';
import '../contacts_chat_screen.dart';
import 'doctor_calendar_screen.dart';
import 'doctor_home_screen.dart';
import 'doctor_search_screen.dart';
import '../profile_screen.dart';
import '../../widgets/navbar_widget.dart'; // Add this import

class DoctorMainScaffold extends StatelessWidget {
  final List<Widget> _screens;

  DoctorMainScaffold({super.key})
      : _screens = [
    DoctorHomeScreen(),
    DoctorSearchScreen(),
    DoctorCalendarScreen(),
    ContactsChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          body: _screens[selectedIndex],
          bottomNavigationBar: NavbarWidget(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              context.read<NavigationCubit>().updateIndex(index);
            },
          ),
        );
      },
    );
  }
}
