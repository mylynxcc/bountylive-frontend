import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class LivestreamScreen extends ConsumerWidget {
  final String streamId;
  const LivestreamScreen({super.key, required this.streamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Camera Preview Placeholder
            Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: BountyLiveColors.primaryGradient,
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.videocam, size: 80, color: Colors.white38),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: BountyLiveColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fiber_manual_record, size: 10, color: Colors.white),
                          SizedBox(width: 4),
                          Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.visibility, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text('0', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.flip_camera_ios,
                              size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StreamControlButton(
                          icon: Icons.mic,
                          label: 'Mic',
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _StreamControlButton(
                          icon: Icons.videocam,
                          label: 'Camera',
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _StreamControlButton(
                          icon: Icons.screen_share,
                          label: 'Share',
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: BountyLiveColors.error,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text('End',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Stream Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Share what you are doing!',
                style: TextStyle(color: BountyLiveColors.textSecondary)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Update your stream title...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check_circle, color: BountyLiveColors.primary),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _StreamControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
