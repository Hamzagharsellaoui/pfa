
part of 'booking_bloc.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String txHash;

  BookingSuccess(this.txHash);
}

class BookingError extends BookingState {
  final String error;

  BookingError(this.error);
}

class BookingDateTimeSelected extends BookingState {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? dateTimeError;

  BookingDateTimeSelected({this.selectedDate, this.selectedTime, this.dateTimeError});
}