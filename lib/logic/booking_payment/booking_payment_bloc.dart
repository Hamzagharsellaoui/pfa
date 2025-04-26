import 'package:bloc/bloc.dart';
import '../../../data/repositories/ConfigureContract2.dart';
import 'package:web3dart/web3dart.dart';

part 'booking_payment_event.dart';
part 'booking_payment_state.dart';

class BookingPaymentBloc extends Bloc<BookingPaymentEvent, BookingPaymentState> {
  final ConfigureTokenContract tokenContract;
  static var consultationPaymentAmount = BigInt.from(10);

  BookingPaymentBloc({required this.tokenContract}) : super(BookingPaymentInitial()) {
    on<PayNow>(_onPayNow);
    on<ResetPaymentStatus>(_onResetPaymentStatus);
  }

  Future<void> _onPayNow(PayNow event, Emitter<BookingPaymentState> emit) async {
    emit(BookingPaymentLoading());
    try {
      final BigInt balance = await tokenContract.checkMyBalance();
      if (balance < consultationPaymentAmount) {
        emit(BookingPaymentError("Insufficient MTK balance ($balance MTK) to pay $consultationPaymentAmount MTK."));
        return;
      }

      final String paymentTxHash = await tokenContract.transferTokens(
        event.doctorAddress,
        event.amount,
      );
      emit(BookingPaymentSuccess(paymentTxHash));
    } catch (e) {
      emit(BookingPaymentError('Payment failed: $e'));
    }
  }

  void _onResetPaymentStatus(ResetPaymentStatus event, Emitter<BookingPaymentState> emit) {
    emit(BookingPaymentInitial());
  }
}