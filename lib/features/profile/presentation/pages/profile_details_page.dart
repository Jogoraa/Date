import 'package:flutter/material.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key, required this.userId, this.profileData});

  final String userId;
  final Map<String, dynamic>? profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Details')),
      body: Center(child: Text('Profile Details for $userId')),
    );
  }
}
