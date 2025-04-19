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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(width: 14),

          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Verified
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (isVerified)
                      const Icon(Icons.verified, color: Colors.teal, size: 18),
                  ],
                ),

                const SizedBox(height: 4),

                // Distance
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "$distance m",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Rating
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < rating.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: index < rating.round()
                            ? Colors.amber
                            : Colors.grey[300],
                      );
                    }),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
