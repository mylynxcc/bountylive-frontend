import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Balance Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: BountyLiveColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    const Text('\$1,234.56',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _BalanceStat(label: 'Available', amount: '\$1,000.00'),
                        const SizedBox(width: 16),
                        _BalanceStat(label: 'Locked', amount: '\$234.56'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.add_circle_outline,
                      label: 'Deposit',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.arrow_upward,
                      label: 'Withdraw',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.swap_horiz,
                      label: 'Transfer',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: index.isEven
                        ? BountyLiveColors.success.withAlpha(30)
                        : BountyLiveColors.error.withAlpha(30),
                    child: Icon(
                      index.isEven ? Icons.arrow_downward : Icons.arrow_upward,
                      color:
                          index.isEven ? BountyLiveColors.success : BountyLiveColors.error,
                      size: 20,
                    ),
                  ),
                  title: Text(index.isEven ? 'Deposit' : 'Withdrawal'),
                  subtitle: Text('2 hours ago'),
                  trailing: Text(
                    index.isEven ? '+\$50.00' : '-\$20.00',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: index.isEven
                          ? BountyLiveColors.success
                          : BountyLiveColors.error,
                    ),
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

class _BalanceStat extends StatelessWidget {
  final String label;
  final String amount;
  const _BalanceStat({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            Text(amount,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? BountyLiveColors.darkCard : BountyLiveColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? BountyLiveColors.darkBorder : BountyLiveColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: BountyLiveColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
