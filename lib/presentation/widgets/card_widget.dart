
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String imageUrl;
  final double rating;
  final int distance;
  final bool isVerified;

  const DoctorCard({
    super.key,
    required this.doctorName,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
                backgroundImage: AssetImage(imageUrl)
            ),
            const SizedBox(width: 12),

            // Doctor's Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isVerified)
                        const Icon(
                          Icons.verified,
                          color: Colors.teal,
                          size: 16,
                        ),
                    ],
                  ),

                  // Distance from user
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      Text(
                        " $distance m",
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),

                  // Star Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: index < rating.round() ? Colors.orange : Colors.grey,
                          size: 18,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon for navigation
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.grey),
              onPressed: () {
                // Add navigation action
              },
            ),
          ],
        ),
      ),
    );
  }
}
