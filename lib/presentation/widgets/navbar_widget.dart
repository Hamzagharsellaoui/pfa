import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label:'' ,),
            NavigationDestination(icon: Icon(Icons.search), label: '',),
            NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: '',),
            NavigationDestination(icon: Icon(Icons.message), label: '',),
            NavigationDestination(icon: Icon(Icons.person), label: '',),
          ],
          labelPadding: EdgeInsets.all(0),
          indicatorShape: UnderlineInputBorder(),
          shadowColor: Colors.black,
        );
      }
  }

