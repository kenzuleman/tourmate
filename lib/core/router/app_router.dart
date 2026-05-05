import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_tools/ai_tools_screen.dart';
import '../../features/ai_tools/chatbot/chatbot_screen.dart';
import '../../features/ai_tools/currency/currency_converter_screen.dart';
import '../../features/ai_tools/expenses/expense_tracker_screen.dart';
import '../../features/ai_tools/packing/packing_screen.dart';
import '../../features/ai_tools/planner/trip_planner_screen.dart';
import '../../features/ai_tools/translator/translator_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/discovery/destination_detail_screen.dart';
import '../../features/discovery/discovery_screen.dart';
import '../../features/discovery/places_list_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/trips/trips_screen.dart';
import '../shell/main_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AuthRefreshNotifier(ref),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (loc == '/splash') return null;

      final user = authStream.asData?.value;
      final isLoggedIn = user != null && user.emailVerified;
      final onAuth = loc == '/auth';

      if (!isLoggedIn && !onAuth) return '/auth';
      if (isLoggedIn && onAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discovery',
                name: 'discovery',
                builder: (context, state) => const DiscoveryScreen(),
                routes: [
                  GoRoute(
                    path: 'destination/:destId',
                    name: 'destination-detail',
                    builder: (context, state) => DestinationDetailScreen(
                      destId: state.pathParameters['destId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'places/:category',
                        name: 'places-list',
                        builder: (context, state) => PlacesListScreen(
                          destId: state.pathParameters['destId']!,
                          category: state.pathParameters['category']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai-tools',
                name: 'ai-tools',
                builder: (context, state) => const AiToolsScreen(),
                routes: [
                  GoRoute(
                    path: 'chatbot',
                    name: 'chatbot',
                    builder: (context, state) => const ChatbotScreen(),
                  ),
                  GoRoute(
                    path: 'translator',
                    name: 'translator',
                    builder: (context, state) => const TranslatorScreen(),
                  ),
                  GoRoute(
                    path: 'packing',
                    name: 'packing',
                    builder: (context, state) => const PackingScreen(),
                  ),
                  GoRoute(
                    path: 'expenses',
                    name: 'expenses',
                    builder: (context, state) => const ExpenseTrackerScreen(),
                  ),
                  GoRoute(
                    path: 'currency',
                    name: 'currency',
                    builder: (context, state) => const CurrencyConverterScreen(),
                  ),
                  GoRoute(
                    path: 'planner',
                    name: 'planner',
                    builder: (context, state) => const TripPlannerScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trips',
                name: 'trips',
                builder: (context, state) => const TripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this.ref) {
    _sub = ref.listen(authStateChangesProvider, (_, _) => notifyListeners());
  }

  final Ref ref;
  late final ProviderSubscription _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
