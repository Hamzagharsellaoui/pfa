part of 'booking_payment_bloc.dart';

abstract class BookingPaymentEvent {}

class PayNow extends BookingPaymentEvent {
  final EthereumAddress doctorAddress;
  final BigInt amount;

  PayNow({required this.doctorAddress, required this.amount});
}

class ResetPaymentStatus extends BookingPaymentEvent {}