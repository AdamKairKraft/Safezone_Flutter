import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/core_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionProvider).user;
    if (user == null) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Panel(
              title: 'Your profile',
              child: Column(
                children: [
                  _row('Name', user.fullName),
                  _row('Email', user.email),
                  _row('Roles', user.roles.map((r) => r.label).join(', '), showDivider: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool showDivider = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: showDivider ? const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.greyBg))) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.sub)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
