import 'package:flutter/material.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          // Log out action
        },
        child: const Text(
          'Log Out',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
