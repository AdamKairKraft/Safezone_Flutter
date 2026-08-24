import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/core_providers.dart';
import 'screens/compliance_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/report_builder_screen.dart';
import 'screens/reporting_list_screen.dart';
import 'screens/roles_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/she_files_screen.dart';
import 'screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // read, not watch: the router itself must stay a stable object across auth-state
  // changes (recreating it would blow away GoRouter's own navigation stack). Reacting
  // to auth changes is what `refreshListenable` is for.
  final authSession = ref.read(authSessionProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authSession,
    redirect: (context, state) {
      final loggedIn = authSession.isAuthenticated;
      final loggingIn = state.matchedLocation == '/login';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShellScreen(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/roles', builder: (context, state) => const RolesScreen()),
          GoRoute(path: '/reports', builder: (context, state) => const ReportingListScreen()),
          GoRoute(
            path: '/reports/new',
            builder: (context, state) => const ReportBuilderScreen(existingReportId: null),
          ),
          GoRoute(
            path: '/reports/:id/edit',
            builder: (context, state) => ReportBuilderScreen(existingReportId: state.pathParameters['id']),
          ),
          GoRoute(path: '/she-files', builder: (context, state) => const SheFilesScreen()),
          GoRoute(path: '/compliance', builder: (context, state) => const ComplianceScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
