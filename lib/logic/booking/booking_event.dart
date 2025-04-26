part of 'booking_bloc.dart';

abstract class BookingEvent {}

class DateSelected extends BookingEvent {
  final DateTime? date;

  DateSelected(this.date);
}

class TimeSelected extends BookingEvent {
  final TimeOfDay? time;

  TimeSelected(this.time);
}

class ConfirmBooking extends BookingEvent {
  final EthereumAddress doctorAddress;
  final BigInt timestamp;

  ConfirmBooking({required this.doctorAddress, required this.timestamp});
}

class ResetBookingStatus extends BookingEvent {}