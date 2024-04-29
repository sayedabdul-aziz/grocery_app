import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, ${FirebaseAuth.instance.currentUser?.displayName}',
                  style: const TextStyle(fontSize: 22)),
              const Text('Hotel for you', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 9),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
