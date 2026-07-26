import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class BountyListScreen extends ConsumerWidget {
  const BountyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bounties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/bounties/create'),
        icon: const Icon(Icons.add),
        label: const Text('Create Bounty'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _CategoryChip(label: 'All', selected: true, onTap: () {}),
                  _CategoryChip(label: 'Gaming', onTap: () {}),
                  _CategoryChip(label: 'Sports', onTap: () {}),
                  _CategoryChip(label: 'Cooking', onTap: () {}),
                  _CategoryChip(label: 'Music', onTap: () {}),
                  _CategoryChip(label: 'Art', onTap: () {}),
                  _CategoryChip(label: 'Fitness', onTap: () {}),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _BountyListItem(
                  title: 'Complete the Ultimate Challenge #${index + 1}',
                  prize: (index + 1) * 250,
                  category: ['Gaming', 'Sports', 'Cooking', 'Music'][index % 4],
                  difficulty: ['Easy', 'Medium', 'Hard', 'Expert'][index % 4],
                  applicants: (index + 1) * 3,
                  timeLeft: '${(index + 1) * 2}d left',
                  onTap: () => context.go('/bounties/${index + 1}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? BountyLiveColors.primary
                : BountyLiveColors.darkCard,
            borderRadius: BorderRadius.circular(20),
            border: !selected
                ? Border.all(color: BountyLiveColors.darkBorder)
                : null,
          ),
          child: Text(label,
              style: TextStyle(
                color: selected ? Colors.white : null,
                fontWeight: selected ? FontWeight.w600 : null,
              )),
        ),
      ),
    );
  }
}

class _BountyListItem extends StatelessWidget {
  final String title;
  final int prize;
  final String category;
  final String difficulty;
  final int applicants;
  final String timeLeft;
  final VoidCallback onTap;
  const _BountyListItem({
    required this.title,
    required this.prize,
    required this.category,
    required this.difficulty,
    required this.applicants,
    required this.timeLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? BountyLiveColors.darkCard : BountyLiveColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? BountyLiveColors.darkBorder : BountyLiveColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: BountyLiveColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(category,
                      style: const TextStyle(
                          fontSize: 11,
                          color: BountyLiveColors.primary,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: BountyLiveColors.warning.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(difficulty,
                      style: const TextStyle(
                          fontSize: 11,
                          color: BountyLiveColors.warning,
                          fontWeight: FontWeight.w500)),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: BountyLiveColors.bountyGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('\$$prize',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people_outline,
                    size: 16, color: BountyLiveColors.textSecondary),
                const SizedBox(width: 4),
                Text('$applicants applicants',
                    style: const TextStyle(
                        color: BountyLiveColors.textSecondary, fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.timer_outlined,
                    size: 16, color: BountyLiveColors.textSecondary),
                const SizedBox(width: 4),
                Text(timeLeft,
                    style: const TextStyle(
                        color: BountyLiveColors.textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
