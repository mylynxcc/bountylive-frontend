import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  final String username;
  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Banner & Avatar
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: BountyLiveColors.primaryGradient,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: -40,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: isDark
                              ? BountyLiveColors.darkBg
                              : BountyLiveColors.lightBg,
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: BountyLiveColors.primary.withAlpha(30),
                            child: Text(
                              username[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: BountyLiveColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: -20,
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () => context.go('/settings'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(username,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  const Text('Web Developer & Streamer',
                                      style: TextStyle(
                                          color: BountyLiveColors.textSecondary)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => context.go('/profile/edit'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 40),
                              ),
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _StatItem(value: '1.2k', label: 'Followers'),
                            const SizedBox(width: 24),
                            _StatItem(value: '345', label: 'Following'),
                            const SizedBox(width: 24),
                            _StatItem(value: '15', label: 'Bounties'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Bio about the user goes here. This is where they can describe themselves.',
                          style: TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        const Text('Streams & Content',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver:            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark
                        ? BountyLiveColors.darkCard
                        : BountyLiveColors.lightCard,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam, size: 32),
                      const SizedBox(height: 8),
                      Text('Stream ${index + 1}',
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                childCount: 6,
              ),
            ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label,
            style: const TextStyle(
                color: BountyLiveColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
