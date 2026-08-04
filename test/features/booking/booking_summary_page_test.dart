import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/features/booking/presentation/booking_summary_page.dart';

void main() {
  testWidgets('summary loads by booking id', (t) async {
    final result =
        await AppDependencies.bookingFlow.createDraftForHotel('summary-page');
    final id = ((result as AppSuccess).data).booking!.id;
    await t.pumpWidget(MaterialApp(home: BookingSummaryPage(bookingId: id)));
    await t.pump();
    expect(find.byType(BookingSummaryPage), findsOneWidget);
  });
}
