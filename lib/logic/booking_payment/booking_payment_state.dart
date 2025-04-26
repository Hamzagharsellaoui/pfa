part of 'booking_payment_bloc.dart';

abstract class BookingPaymentState {}

class BookingPaymentInitial extends BookingPaymentState {}

class BookingPaymentLoading extends BookingPaymentState {}

class BookingPaymentSuccess extends BookingPaymentState {
  final String txHash;

  BookingPaymentSuccess(this.txHash);
}

class BookingPaymentError extends BookingPaymentState {
  final String error;

  BookingPaymentError(this.error);
}