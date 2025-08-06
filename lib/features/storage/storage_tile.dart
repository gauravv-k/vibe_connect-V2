import 'package:flutter/material.dart';

class StorageTile extends StatelessWidget {
  final String sessionTitle;
  final String subtitle;
  final String createdBy;
  final Color color;
  final VoidCallback onTap;

  const StorageTile({
    super.key,
    required this.sessionTitle,
    required this.subtitle,
    required this.createdBy,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    sessionTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Created by: $createdBy',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            //const SizedBox(height: 0.2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
