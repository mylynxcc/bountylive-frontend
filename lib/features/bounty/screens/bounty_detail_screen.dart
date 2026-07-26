import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class BountyDetailScreen extends ConsumerWidget {
  final String bountyId;
  const BountyDetailScreen({super.key, required this.bountyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Bounty #$bountyId')),
      body: const Center(child: Text('Bounty Detail')),
    );
  }
}
