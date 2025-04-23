import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage("assets/images/profile.jpg"),
          ),
          const SizedBox(width: 12),

          // Greeting Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "JUN 25, 2025",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text(
                      "Hello, John!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text("👋", style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 16, color: Colors.purple),
                    SizedBox(width: 4),
                    Text(
                      "Sfax, Tunisia",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                )
              ],
            ),
          ),

          // Notification Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
