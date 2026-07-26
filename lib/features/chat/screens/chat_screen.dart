import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  final String streamId;
  const ChatScreen({super.key, required this.streamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat - Stream $streamId')),
      body: const Center(child: Text('Chat Interface')),
    );
  }
}
