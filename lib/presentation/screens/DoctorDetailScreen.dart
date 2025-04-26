import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

import '../../../logic/doctor_detail/doctor_detail_bloc.dart';
import '../../../logic/doctor_detail/doctor_detail_event.dart';
import '../../../logic/doctor_detail/doctor_detail_state.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../data/repositories/ConfigureContract1.dart'; // Copied from app2
import '../../data/repositories/ConfigureContract2.dart'; // Copied from app2
import '../../logic/booking/booking_bloc.dart';
import '../../logic/booking_payment/booking_payment_bloc.dart';
import '../widgets/card_widget.dart';
import 'mastercard_payment_screen.dart';
import 'profile_screen.dart'; // Assuming you have this or will create it

// Define a Doctor class to match expected data structure
class Doctor {
  final String name;
  final EthereumAddress address;

  Doctor({required this.name, required this.address});
}

class DoctorDetailScreen extends StatelessWidget {
  final int doctorId;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  const DoctorDetailScreen({
    super.key,
    required this.doctorId,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    print("DoctorDetailScreen: Date = $selectedDate, Time = $selectedTime");
    final contract = ConfigureContract.auto();
    final tokenContract = ConfigureTokenContract.auto();

    return MultiBlocProvider(
      providers: [
        BlocProvider<DoctorDetailBloc>(
          create: (_) => DoctorDetailBloc(DoctorRepository())..add(FetchDoctorDetail(doctorId)),
        ),
        BlocProvider<BookingBloc>(
          create: (_) => BookingBloc(contract: contract),
        ),
        BlocProvider<BookingPaymentBloc>(
          create: (_) => BookingPaymentBloc(tokenContract: tokenContract),
        ),
      ],
      child: Scaffold(

        body: BlocBuilder<DoctorDetailBloc, DoctorDetailState>(
          builder: (context, state) {
            if (state is DoctorDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorDetailLoaded) {
              return BookingContent(
                doctor: Doctor(
                  name: state.doctor.name,
                  address: EthereumAddress.fromHex(
                    "0x7e01Fc8F359389f82336325d3552Ef6b36a04cf7", // Placeholder; replace with actual address
                  ),
                ),
                selectedDate: selectedDate,
                selectedTime: selectedTime,
              );
            } else if (state is DoctorDetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class BookingContent extends StatelessWidget {
  final Doctor doctor;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const BookingContent({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
        DoctorCard(
          doctorName: "Dr. Tarek Frikha",
          imageUrl: "assets/images/frikh-3379374-small.gif",
          rating: 2,
          distance: 100,
        ),
          const SizedBox(height: 20),
          const PaymentDetails(),
          const SizedBox(height: 20),
          const Text(
            'Payment Methods',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          PaymentMethodTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const PaymentModal(),
              );
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: BlocConsumer<BookingBloc, BookingState>(
              listener: (context, state) {
                if (state is BookingSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Booking Confirmed! Tx: ${state.txHash}"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                  _showPaymentDialog(context, doctor, selectedDate, selectedTime);
                } else if (state is BookingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Booking Failed: ${state.error}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A1B9A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: state is BookingLoading
                      ? null
                      : () {
                    final timestamp = _getTimestampInSeconds(selectedDate, selectedTime);
                    if (timestamp != null) {
                      context.read<BookingBloc>().add(
                        ConfirmBooking(
                          doctorAddress: doctor.address,
                          timestamp: timestamp,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a future date and time.")),
                      );
                    }
                  },
                  child: state is BookingLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'BOOK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          BlocConsumer<BookingPaymentBloc, BookingPaymentState>(
            listener: (context, state) {
              if (state is BookingPaymentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Payment Successful! Tx: ${state.txHash}"),
                    backgroundColor: Colors.green,
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                });
              } else if (state is BookingPaymentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Payment Failed: ${state.error}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is BookingPaymentError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Payment Status: ${state.error}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  BigInt? _getTimestampInSeconds(DateTime selectedDate, TimeOfDay selectedTime) {
    final DateTime combined = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    if (combined.isBefore(DateTime.now())) {
      return null;
    }
    return BigInt.from(combined.millisecondsSinceEpoch ~/ 1000);
  }

  void _showPaymentDialog(
      BuildContext context,
      Doctor doctor,
      DateTime selectedDate,
      TimeOfDay selectedTime,
      ) {
    final bookingPaymentBloc = context.read<BookingPaymentBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: bookingPaymentBloc,
          child: AlertDialog(
            title: const Text("Consultation Booked"),
            content: Text(
              "Your consultation is booked. Would you like to pay the ${BookingPaymentBloc.consultationPaymentAmount} MTK fee now?",
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Pay Later"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              BlocBuilder<BookingPaymentBloc, BookingPaymentState>(
                builder: (blocContext, paymentState) {
                  return ElevatedButton(
                    child: paymentState is BookingPaymentLoading
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text("Pay Now"),
                    onPressed: paymentState is BookingPaymentLoading
                        ? null
                        : () {
                      // dispatch before closing dialog
                      blocContext.read<BookingPaymentBloc>().add(
                        PayNow(
                          doctorAddress: doctor.address,
                          amount: BookingPaymentBloc.consultationPaymentAmount,
                        ),
                      );
                      Navigator.of(dialogContext).pop();
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class BookingDoctorCard extends StatelessWidget {
  final Doctor doctor;

  const BookingDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('50m', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Icon(Icons.verified, color: Colors.green),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 16),
                  SizedBox(width: 2),
                  Text('3.1', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder widgets to resolve undefined class errors
class PaymentDetails extends StatelessWidget {
  const PaymentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Payment Details Placeholder",
      style: TextStyle(fontSize: 16),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final VoidCallback onTap;

  const PaymentMethodTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Select Payment Method"),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}

class PaymentModal extends StatefulWidget {
  const PaymentModal({super.key});

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  String selectedMethod = 'Metamask'; // Default selected

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Payment Methods',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _buildPaymentOption(
            'Metamask',
            Image.asset('assets/images/metamask.png', width: 60, height: 60),
            isSelected: selectedMethod == 'Metamask',
            onTap: () {
              setState(() => selectedMethod = 'Metamask');
            },
          ),
          const SizedBox(height: 20),

          _buildPaymentOption(
            'Master Card',
            Image.asset('assets/images/mastercard.png', width: 60, height: 60),
            isSelected: selectedMethod == 'Master Card',
            onTap: () {
              setState(() => selectedMethod = 'Master Card');
            },
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the modal
              if (selectedMethod == 'Master Card') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MasterCardPaymentScreen()),
                );
              }
              // You can handle Metamask or others here too if needed
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Apply',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      String title,
      Widget trailing, {
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6A1B9A).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6A1B9A) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFF6A1B9A) : Colors.black,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
