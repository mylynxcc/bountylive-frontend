import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneVerificationScreen extends ConsumerWidget {
  const PhoneVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone')),
      body: const Center(child: Text('Phone Verification')),
    );
  }
}
