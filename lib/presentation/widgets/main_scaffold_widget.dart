import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../navigation/NavigationCubit.dart';
import '../screens/calendar_screen.dart';
import '../screens/contacts_chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../widgets/navbar_widget.dart'; // Add this import

class MainScaffold extends StatelessWidget {
  final List<Widget> _screens;

  MainScaffold({super.key})
      : _screens = [
    HomeScreen(),
    SearchScreen(),
    const CalendarScreen(),
    ContactsChatScreen(),
    const ProfileScreen(),
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
