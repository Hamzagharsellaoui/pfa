import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../data/repositories/ConfigureContract1.dart';
import 'package:web3dart/web3dart.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ConfigureContract contract;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  BookingBloc({required this.contract}) : super(BookingInitial()) {
    on<DateSelected>(_onDateSelected);
    on<TimeSelected>(_onTimeSelected);
    on<ConfirmBooking>(_onConfirmBooking);
    on<ResetBookingStatus>(_onResetBookingStatus);
  }

  void _onDateSelected(DateSelected event, Emitter<BookingState> emit) {
    _selectedDate = event.date;
    emit(_updateDateTimeState());
  }

  void _onTimeSelected(TimeSelected event, Emitter<BookingState> emit) {
    _selectedTime = event.time;
    emit(_updateDateTimeState());
  }

  BookingDateTimeSelected _updateDateTimeState() {
    String? dateTimeError;
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime combined = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      if (combined.isBefore(DateTime.now())) {
        dateTimeError = "Selected date/time must be in the future.";
      }
    }
    return BookingDateTimeSelected(selectedDate: _selectedDate, selectedTime: _selectedTime, dateTimeError: dateTimeError);
  }

  Future<void> _onConfirmBooking(ConfirmBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final String txHash = await contract.bookConsultation(
        event.doctorAddress,
        event.timestamp,
      );
      emit(BookingSuccess(txHash));
    } catch (e) {
      emit(BookingError('Booking failed: $e'));
    }
  }

  void _onResetBookingStatus(ResetBookingStatus event, Emitter<BookingState> emit) {
    emit(BookingInitial());
  }
}