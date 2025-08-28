import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatelessWidget {
  const PhoneVerificationPage({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Verification')),
      body: Center(child: Text('Phone Verification Page for $phoneNumber')),
    );
  }
}
