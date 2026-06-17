import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String userName;
  final String comment;
  final double rating;

  const CommentWidget({
    super.key,
    required this.userName,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),

      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                const CircleAvatar(
                  child: Icon(Icons.person),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),

                const SizedBox(width: 4),

                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              comment,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}