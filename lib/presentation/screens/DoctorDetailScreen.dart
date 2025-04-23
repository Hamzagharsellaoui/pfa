import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/doctor_detail/doctor_detail_bloc.dart';
import '../../../logic/doctor_detail/doctor_detail_event.dart';
import '../../../logic/doctor_detail/doctor_detail_state.dart';
import '../../../data/repositories/doctor_repository.dart';

class DoctorDetailScreen extends StatelessWidget {
  final int doctorId;

  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorDetailBloc(DoctorRepository())
        ..add(FetchDoctorDetail(doctorId)),
      child: Scaffold(
        appBar: AppBar(

          title: const Text('Doctor Booking'),
          centerTitle: true,
        ),
        body: BlocBuilder<DoctorDetailBloc, DoctorDetailState>(
          builder: (context, state) {
            if (state is DoctorDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorDetailLoaded) {
              // Once doctor is loaded, show booking UI
              return const BookingContent();
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

/// Booking UI integrated into DoctorDetailScreen
class BookingContent extends StatelessWidget {
  const BookingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 20),
          const BookingDoctorCard(),
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
          const Spacer(),
          Row(
            children: [

              const SizedBox(width: 10),

            ],
          ),
        ],
      ),
    );
  }
}

/// Widgets for the booking UI
class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.label, this.isCompleted = false});

  final String label;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isCompleted ? Color(0xFF6A1B9A) : Colors.grey.shade300,
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.black : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class StepLine extends StatelessWidget {
  const StepLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 60,
      color: Colors.grey.shade300,
    );
  }
}

class BookingDoctorCard extends StatelessWidget {
  const BookingDoctorCard({super.key});

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
              children: const [
                Text(
                  'Dr. Hannibal Lector',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
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

class PaymentDetails extends StatelessWidget {
  const PaymentDetails({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Detail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('1x Consultation Package (30min)'),
              Text('\$250.00'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Admin Fee'),
              Text('\$44.00'),
            ],
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$87.52', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final VoidCallback onTap;

  const PaymentMethodTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
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
              Navigator.pop(context, selectedMethod); // optionally return the selected method
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
