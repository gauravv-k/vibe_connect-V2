import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StorageTile extends StatelessWidget {
  final String sessionTitle;
  final String subtitle;
  final String createdByUid;
  final Color color;
  final VoidCallback onTap;

  const StorageTile({
    super.key,
    required this.sessionTitle,
    required this.subtitle,
    required this.createdByUid,
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
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('user').doc(createdByUid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  final userName = snapshot.data!['name'] as String? ?? 'Unknown';
                  return Text(
                    'Created by: $userName',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return const Text(
                    'Created by: ...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  );
                }
              },
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
