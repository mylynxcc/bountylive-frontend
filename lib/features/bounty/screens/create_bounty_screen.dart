import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBountyScreen extends ConsumerWidget {
  const CreateBountyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Bounty')),
      body: const Center(child: Text('Create Bounty Form')),
    );
  }
}
