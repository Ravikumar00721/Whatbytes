import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.white24,
      child: Icon(
        Icons.lock_person,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}
