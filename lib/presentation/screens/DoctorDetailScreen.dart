import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/doctor_detail/doctor_detail_bloc.dart';
import '../../../logic/doctor_detail/doctor_detail_event.dart';
import '../../../logic/doctor_detail/doctor_detail_state.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/smart_contract_interaction/Web3Service.dart';
import '../../../data/models/doctor.dart'; // Ensure this exists

class DoctorDetailScreen extends StatelessWidget {
  final int doctorId;

  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorDetailBloc(DoctorRepository())..add(FetchDoctorDetail(doctorId)),
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
              return BookingContent(doctor: state.doctor);
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

  const BookingContent({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctorName = doctor.name ?? "Unknown Doctor";
    final doctorLocation = doctor.location ?? "Sfax";
    final doctorWallet = doctor.walletAddress ?? "0x0000000000000000000000000000000000000000";
    final doctorRating = doctor.rating ?? 4.5;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          BookingDoctorCard(
            name: doctorName,
            location: doctorLocation,
            rating: doctorRating,
          ),
          const SizedBox(height: 20),
          const PaymentDetails(), // Placeholder widget below
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
                builder: (context) => PaymentModal(
                  onMethodSelected: (selectedMethod) async {
                    if (selectedMethod == 'Metamask') {
                      handleMetaMaskBooking(context, doctorWallet);
                    } else {
                      print('Selected: $selectedMethod');
                    }
                  },
                ),
              );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void handleMetaMaskBooking(BuildContext context, String doctorWallet) async {
    final web3 = Web3Service(rpcUrl: 'https://rpc.ankr.com/eth_goerli');

    try {
      await web3.connectWallet(
        appName: 'TeleMed',
        appDescription: 'Decentralized Medical Booking',
        appUrl: 'https://yourapp.com',
        appIcon: 'https://yourapp.com/icon.png',
        rpcUrl: 'https://rpc.ankr.com/eth_goerli',
      );

      await web3.initContract();

      await web3.bookConsultation(
        doctorAddress: doctorWallet,
        dateTime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        description: "Booking via MetaMask",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking successful via MetaMask')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

// Placeholder for missing component
class PaymentDetails extends StatelessWidget {
  const PaymentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Payment Details Placeholder");
  }
}

class PaymentMethodTile extends StatelessWidget {
  final VoidCallback onTap;

  const PaymentMethodTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.payment),
      title: const Text("Pay with MetaMask"),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class PaymentModal extends StatelessWidget {
  final Function(String) onMethodSelected;

  const PaymentModal({super.key, required this.onMethodSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          title: const Text("Metamask"),
          onTap: () {
            Navigator.pop(context);
            onMethodSelected("Metamask");
          },
        ),
        ListTile(
          title: const Text("Credit Card"),
          onTap: () {
            Navigator.pop(context);
            onMethodSelected("Card");
          },
        ),
      ],
    );
  }
}

class BookingDoctorCard extends StatelessWidget {
  final String name;
  final String location;
  final double rating;

  const BookingDoctorCard({
    super.key,
    required this.name,
    required this.location,
    required this.rating,
  });

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
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.verified, color: Colors.green),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 2),
                  Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
