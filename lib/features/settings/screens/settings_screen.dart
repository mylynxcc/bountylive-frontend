import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider).valueOrNull ?? true;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _SectionTitle('Appearance'),
            _SettingTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              trailing: Switch(
                value: isDark,
                onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
                activeColor: BountyLiveColors.primary,
              ),
            ),
            const Divider(),
            const _SectionTitle('Notifications'),
            _SettingTile(
              icon: Icons.push_pin_outlined,
              title: 'Push Notifications',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            _SettingTile(
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            _SettingTile(
              icon: Icons.sms_outlined,
              title: 'SMS Notifications',
              trailing: Switch(value: false, onChanged: (_) {}),
            ),
            const Divider(),
            const _SectionTitle('Account'),
            _SettingTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'English',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            const _SectionTitle('About'),
            _SettingTile(
              icon: Icons.info_outline,
              title: 'Version',
              subtitle: '1.0.0',
            ),
            _SettingTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: BountyLiveColors.primary)),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
