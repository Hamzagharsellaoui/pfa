import 'package:flutter/material.dart';

class DoctorCalendarScreen extends StatelessWidget {
  const DoctorCalendarScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Calendar'),
      ),
      // body: DoctorAppointmentCalendar(), // Custom doctor calendar widget
    );
  }
}

class DoctorAppointmentCalendar {
  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other;
  }
}