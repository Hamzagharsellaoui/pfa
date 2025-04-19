import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pfa_flutter/presentation/widgets/card_widget.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_event.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat.yMMMEd().format(DateTime.now());

    const mainColor = Color(0xFF7C3AED); // Soft purple
    const backgroundColor = Color(0xFFF4F4F7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: FutureBuilder<String?>(
            future: AuthBloc.getUsernameFromToken(),
            builder: (context, snapshot) {
              final username = snapshot.data ?? "User";

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage(
                          "assets/images/20241020_180030.jpg",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Hi, $username 👋",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: const [
                              Icon(Icons.location_on,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "Sfax, Tunisia",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded,
                            size: 26, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout,
                            size: 26, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Logout"),
                              content: const Text(
                                  "Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text("Logout"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<AuthBloc>()
                                        .add(LogoutEvent());
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            DoctorCard(
              doctorName: "Dr. Tarek Frikha",
              imageUrl: "assets/images/frikh-3379374-small.gif",
              rating: 2,
              distance: 100,
            ),
            const SizedBox(height: 16),
            DoctorCard(
              doctorName: "Dr. Tarek Frikha",
              imageUrl: "assets/images/frikh-3379374-small.gif",
              rating: 2,
              distance: 100,
            ),
          ],
        ),
      ),
    );
  }
}
