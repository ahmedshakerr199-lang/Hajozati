import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/core/theme/app_theme.dart';
import 'package:hajozati/features/booking/presentation/booking_confirmation_page.dart';
import 'package:hajozati/features/booking/presentation/booking_details_page.dart';
import 'package:hajozati/features/booking/presentation/booking_summary_page.dart';
import 'package:hajozati/features/booking/presentation/booking_view_model.dart';
import 'package:hajozati/features/booking/presentation/room_selection_page.dart';
import 'package:hajozati/features/explore/presentation/pages/destination_details_page.dart';
import 'package:hajozati/features/explore/presentation/pages/explore_iraq_page.dart';
import 'package:hajozati/features/home/presentation/pages/home_page.dart';
import 'package:hajozati/features/hotels/presentation/pages/hotel_details_page.dart';
import 'package:hajozati/features/search/presentation/search_page.dart';

/// Layout regression coverage for the redesigned Arabic screens.
void main() {
  const widths = [320.0, 375.0, 390.0, 430.0];

  Future<void> pumpAtWidths(
    WidgetTester tester,
    Widget Function() page,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final width in widths) {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          builder: (context, child) => MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
          home: page(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull,
          reason: 'layout failure at $width px');
    }
  }

  testWidgets('home remains stable in RTL at phone widths', (tester) async {
    await pumpAtWidths(tester, HomePage.new);
  });

  testWidgets('search remains stable in RTL at phone widths', (tester) async {
    await pumpAtWidths(tester, SearchPage.new);
  });

  testWidgets('explore remains stable in RTL at phone widths', (tester) async {
    await pumpAtWidths(tester, ExploreIraqPage.new);
  });

  testWidgets('hotel detail remains stable in RTL at phone widths',
      (tester) async {
    await pumpAtWidths(
      tester,
      () => HotelDetailsPage(
        hotelId: 'hotel-1',
        repository: AppDependencies.hotels,
      ),
    );
  });

  testWidgets('destination detail remains stable in RTL at phone widths',
      (tester) async {
    await pumpAtWidths(
      tester,
      () => const DestinationDetailsPage(destinationId: 'destination-1'),
    );
  });

  testWidgets('booking screens remain stable in RTL at phone widths',
      (tester) async {
    final result =
        await AppDependencies.bookingFlow.createDraftForHotel('hotel-1');
    final viewModel = (result as AppSuccess<BookingViewModel>).data;
    final bookingId = viewModel.booking!.id;

    await pumpAtWidths(
      tester,
      () => RoomSelectionPage(bookingId: bookingId),
    );
    await pumpAtWidths(
      tester,
      () => BookingDetailsPage(bookingId: bookingId),
    );
    await pumpAtWidths(
      tester,
      () => BookingSummaryPage(bookingId: bookingId),
    );
    await pumpAtWidths(
      tester,
      () => BookingConfirmationPage(bookingId: bookingId),
    );
  });
}
