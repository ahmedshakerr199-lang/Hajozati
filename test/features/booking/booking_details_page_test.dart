import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/booking/presentation/booking_details_page.dart';

void main() {
  testWidgets('invalid booking id shows an error state', (t) async {
    await t.pumpWidget(
        const MaterialApp(home: BookingDetailsPage(bookingId: 'missing')));
    await t.pump();
    expect(find.text('تعذر تحميل مسودة الحجز.'), findsOneWidget);
  });
}
