import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/features/booking/presentation/room_selection_page.dart';

void main() {
  testWidgets('uses booking id to load its shared draft', (t) async {
    final result =
        await AppDependencies.bookingFlow.createDraftForHotel('room-page');
    final id = ((result as AppSuccess).data).booking!.id;
    await t.pumpWidget(MaterialApp(home: RoomSelectionPage(bookingId: id)));
    await t.pump();
    expect(find.byType(RoomSelectionPage), findsOneWidget);
  });
}
