import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _FeedTab(),
    const _ExploreTab(),
    const _CreateTab(),
    const _ActivityTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? BountyLiveColors.darkSurface
              : BountyLiveColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: BountyLiveColors.primary,
            unselectedItemColor: isDark
                ? BountyLiveColors.textSecondary
                : BountyLiveColors.textDarkSecondary,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Activity',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BountyLive',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Badge(
                              label: Text('3'),
                              child: Icon(Icons.notifications_outlined),
                            ),
                            onPressed: () => context.go('/notifications'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Live Now Section
                  _SectionHeader(
                    title: 'Live Now',
                    action: 'See All',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => _LiveStreamCard(
                        username: 'Creator ${index + 1}',
                        title: 'Live Stream ${index + 1}',
                        viewers: (index + 1) * 1000,
                        onTap: () => context.go('/streams/${index + 1}'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Trending Bounties
                  _SectionHeader(
                    title: 'Trending Bounties',
                    action: 'View All',
                    onAction: () => context.go('/bounties'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _BountyCard(
                title: 'Challenge #${index + 1}',
                prize: (index + 1) * 100,
                category: ['Gaming', 'Sports', 'Cooking', 'Music', 'Art'][
                    index % 5],
                difficulty: ['Easy', 'Medium', 'Hard'][index % 3],
                onTap: () => context.go('/bounties/${index + 1}'),
              ),
              childCount: 10,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Explore'));
  }
}

class _CreateTab extends StatelessWidget {
  const _CreateTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Create'));
  }
}

class _ActivityTab extends StatelessWidget {
  const _ActivityTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Activity'));
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile'));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(action),
        ),
      ],
    );
  }
}

class _LiveStreamCard extends StatelessWidget {
  final String username;
  final String title;
  final int viewers;
  final VoidCallback onTap;

  const _LiveStreamCard({
    required this.username,
    required this.title,
    required this.viewers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [BountyLiveColors.primaryDark, BountyLiveColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: BountyLiveColors.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fiber_manual_record, size: 10, color: Colors.white),
                    SizedBox(width: 4),
                    Text('LIVE',
                        style: TextStyle(fontSize: 10, color: Colors.white)),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.visibility, size: 12, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('${viewers ~/ 1000}k',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BountyCard extends StatelessWidget {
  final String title;
  final int prize;
  final String category;
  final String difficulty;
  final VoidCallback onTap;

  const _BountyCard({
    required this.title,
    required this.prize,
    required this.category,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: BountyLiveColors.primary.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(category,
                              style: const TextStyle(
                                  fontSize: 11, color: BountyLiveColors.primary)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: BountyLiveColors.warning.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(difficulty,
                              style: const TextStyle(
                                  fontSize: 11, color: BountyLiveColors.warning)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: BountyLiveColors.bountyGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '\$$prize',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
