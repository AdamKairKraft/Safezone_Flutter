import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/core_providers.dart';
import '../providers/session_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/sync_status_indicator.dart';

class _NavItem {
  const _NavItem(this.path, this.label, this.icon);
  final String path;
  final String label;
  final IconData icon;
}

const _navItems = [
  _NavItem('/', 'Dashboard', Icons.space_dashboard_outlined),
  _NavItem('/roles', 'Roles & Responsibilities', Icons.badge_outlined),
  _NavItem('/reports', 'Reporting', Icons.assignment_outlined),
  _NavItem('/she-files', 'SHE Files', Icons.folder_shared_outlined),
  _NavItem('/compliance', 'Compliance Tracker', Icons.fact_check_outlined),
  _NavItem('/settings', 'Settings', Icons.settings_outlined),
];

/// Tablet-adapted persistent side nav (landscape) with a drawer fallback for narrow
/// widths - per FLUTTER_BUILD_PROMPT.md, adapted from safezone-web's AppShell rather
/// than a pixel-identical port of its narrow sidebar.
class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key, required this.child});

  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _navItems.indexWhere((item) => item.path == location);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 720;
    final nav = _SideNav(currentIndex: _currentIndex(context));

    return Scaffold(
      drawer: isWide ? null : Drawer(child: nav),
      appBar: isWide
          ? null
          : AppBar(title: const Text('SafeZone'), backgroundColor: AppColors.navy, foregroundColor: Colors.white),
      body: Row(
        children: [
          if (isWide) SizedBox(width: 220, child: nav),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SiteBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SiteBar extends ConsumerWidget {
  const _SiteBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesAsync = ref.watch(sitesProvider);
    final sites = sitesAsync.valueOrNull ?? const [];
    if (sites.length <= 1) return const SizedBox.shrink();

    final selectedSiteId = ref.watch(selectedSiteIdProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Site', style: TextStyle(fontSize: 12, color: AppColors.sub)),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedSiteId,
            underline: const SizedBox.shrink(),
            style: const TextStyle(fontSize: 12, color: AppColors.text),
            items: sites.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
            onChanged: (value) => ref.read(selectedSiteIdProvider.notifier).state = value,
          ),
        ],
      ),
    );
  }
}

class _SideNav extends ConsumerWidget {
  const _SideNav({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionProvider).user;

    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(6)),
                  child: const Text('SZ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                const Text('SafeZone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (var i = 0; i < _navItems.length; i++) _navTile(context, _navItems[i], i == currentIndex),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: SyncStatusIndicator()),
          const SizedBox(height: 12),
          if (user != null) _userFooter(context, ref, user.fullName),
        ],
      ),
    );
  }

  Widget _navTile(BuildContext context, _NavItem item, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? AppColors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            context.go(item.path);
            if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: selected ? Colors.white : const Color(0xFFC4C9D4)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: selected ? Colors.white : const Color(0xFFC4C9D4),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userFooter(BuildContext context, WidgetRef ref, String fullName) {
    final initials = fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF333C4D)))),
      child: Row(
        children: [
          CircleAvatar(radius: 11, backgroundColor: const Color(0xFF4B5568), child: Text(initials, style: const TextStyle(fontSize: 10, color: Colors.white))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(fullName, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFC4C9D4), fontSize: 12)),
          ),
          TextButton(
            onPressed: () => ref.read(authRepositoryProvider).logout(),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFC4C9D4), padding: EdgeInsets.zero, minimumSize: const Size(40, 20)),
            child: const Text('Log out', style: TextStyle(fontSize: 11, decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}
