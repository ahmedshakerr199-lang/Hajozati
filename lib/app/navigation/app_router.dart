import 'package:flutter/material.dart';

import '../../features/explore/presentation/pages/explore_iraq_page.dart';
import '../../features/explore/presentation/pages/destination_details_page.dart';
import '../../features/hotels/presentation/pages/hotel_details_page.dart';
import '../app_dependencies.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/nearby/presentation/pages/nearby_hotels_page.dart';
import '../../features/search/presentation/search_page.dart';
import '../../features/booking/presentation/room_selection_page.dart';
import '../../features/booking/presentation/booking_details_page.dart';
import '../../features/booking/presentation/booking_summary_page.dart';
import '../../features/booking/presentation/booking_confirmation_page.dart';
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
        AppRoutes.search => MaterialPageRoute(
            builder: (_) => const SearchPage(), settings: settings),
        AppRoutes.roomSelection when settings.arguments is String =>
          MaterialPageRoute(
              builder: (_) =>
                  RoomSelectionPage(bookingId: settings.arguments! as String),
              settings: settings),
        AppRoutes.bookingDetails when settings.arguments is String =>
          MaterialPageRoute(
              builder: (_) =>
                  BookingDetailsPage(bookingId: settings.arguments! as String),
              settings: settings),
        AppRoutes.bookingSummary when settings.arguments is String =>
          MaterialPageRoute(
              builder: (_) =>
                  BookingSummaryPage(bookingId: settings.arguments! as String),
              settings: settings),
        AppRoutes.bookingConfirmation when settings.arguments is String =>
          MaterialPageRoute(
              builder: (_) => BookingConfirmationPage(
                  bookingId: settings.arguments! as String),
              settings: settings),
        AppRoutes.hotelDetails when settings.arguments is String =>
          MaterialPageRoute(
              builder: (_) => HotelDetailsPage(
                  hotelId: settings.arguments! as String,
                  repository: AppDependencies.hotels),
              settings: settings),
        AppRoutes.destinationDetails when settings.arguments is String =>
          MaterialPageRoute(
              builder: (_) => DestinationDetailsPage(
                  destinationId: settings.arguments! as String),
              settings: settings),
        _ => MaterialPageRoute(
            builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('مسار غير معروف')),
                body: Center(
                    child: Text('لا يمكن فتح المسار: ${settings.name ?? ''}'))),
            settings: settings),
      };
}
