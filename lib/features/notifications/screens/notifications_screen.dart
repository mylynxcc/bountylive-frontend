import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark All Read'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 8,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final types = [
              Icons.favorite,
              Icons.monetization_on,
              Icons.videocam,
              Icons.emoji_events,
              Icons.person_add,
              Icons.check_circle,
              Icons.message,
              Icons.star,
            ];
            final colors = [
              BountyLiveColors.error,
              BountyLiveColors.success,
              BountyLiveColors.primary,
              BountyLiveColors.warning,
              BountyLiveColors.info,
              BountyLiveColors.accent,
              BountyLiveColors.primaryLight,
              BountyLiveColors.secondary,
            ];
            final titles = [
              'New Follower',
              'Donation Received',
              'Stream Reminder',
              'Achievement Unlocked',
              'Follow Request',
              'Bounty Completed',
              'New Message',
              'Level Up!',
            ];
            final subtitles = [
              'JohnDoe started following you',
              'JaneDoe donated $10',
              'Your stream starts in 30 minutes',
              'You earned "First Stream"!',
              'User123 wants to follow you',
              'Your bounty submission was approved',
              'Sarah sent you a message',
              'You reached Level 5!',
            ];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: colors[index].withAlpha(30),
                child: Icon(types[index], color: colors[index], size: 22),
              ),
              title:
                  Text(titles[index], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(subtitles[index]),
              trailing: const Text('2h'),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
