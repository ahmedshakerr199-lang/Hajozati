import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/booking/presentation/booking_details_page.dart';
import 'booking_ui_test_helper.dart';

void main() {
  testWidgets('shows booking details and continue action', (t) async {
    final vm = createBookingViewModel();
    await vm.initializeBooking('hotel');
    await t.pumpWidget(MaterialApp(home: BookingDetailsPage(viewModel: vm)));
    expect(find.textContaining('الليالي'), findsOneWidget);
    expect(find.text('متابعة'), findsOneWidget);
  });
}
