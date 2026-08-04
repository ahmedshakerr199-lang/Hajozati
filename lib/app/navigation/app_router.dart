import 'package:flutter/material.dart';

import '../../features/explore/presentation/pages/explore_iraq_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/nearby/presentation/pages/nearby_hotels_page.dart';
import 'app_routes.dart';

/// Central, ID-only route table. Detail routes can be extended for deep links.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) =>
      switch (settings.name) {
        AppRoutes.home => MaterialPageRoute(
            builder: (_) => const HomePage(), settings: settings),
        AppRoutes.explore => MaterialPageRoute(
            builder: (_) => const ExploreIraqPage(), settings: settings),
        AppRoutes.nearby => MaterialPageRoute(
            builder: (_) => const NearbyHotelsPage(), settings: settings),
        _ => MaterialPageRoute(
            builder: (_) => const HomePage(), settings: settings),
      };
}
