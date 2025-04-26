import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String userId;
  final double radius;
  final Color borderColor;
  final double borderWidth;

  const ProfileImageWidget({
    Key? key,
    required this.userId,
    this.radius = 40.0,
    required this.borderColor,
    this.borderWidth = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage("assets/images/frikh-3379374-small.gif"),
        backgroundColor: Colors.grey.shade200, // Fallback color if image fails to load
      ),
    );
  }
}