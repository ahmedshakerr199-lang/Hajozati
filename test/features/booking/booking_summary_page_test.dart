import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/booking/presentation/booking_summary_page.dart';
import 'booking_ui_test_helper.dart';

void main() {
  testWidgets('shows summary confirmation action', (t) async {
    final vm = createBookingViewModel();
    await vm.initializeBooking('hotel');
    await t.pumpWidget(MaterialApp(home: BookingSummaryPage(viewModel: vm)));
    expect(find.textContaining('الفندق'), findsOneWidget);
    expect(find.text('تأكيد الحجز'), findsOneWidget);
  });
}
