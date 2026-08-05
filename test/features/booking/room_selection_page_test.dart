import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/features/booking/presentation/room_selection_page.dart';

void main() {
  Future<String> createId() async {
    final result =
        await AppDependencies.bookingFlow.createDraftForHotel('hotel-1');
    return ((result as AppSuccess).data).booking!.id;
  }

  testWidgets('loads actual hotel room types using booking id only',
      (tester) async {
    final id = await createId();
    await tester
        .pumpWidget(MaterialApp(home: RoomSelectionPage(bookingId: id)));
    await tester.pumpAndSettle();
    expect(find.byType(RoomSelectionPage), findsOneWidget);
    expect(find.text('غرفة قياسية'), findsOneWidget);
    expect(find.textContaining('السعة:'), findsWidgets);
    expect(find.textContaining('د.ع / ليلة'), findsWidgets);
  });

  testWidgets('unknown booking id shows an error state', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: RoomSelectionPage(bookingId: 'unknown')));
    await tester.pumpAndSettle();
    expect(find.text('تعذر تحميل مسودة الحجز.'), findsOneWidget);
  });

  test('coordinator reuses view model for the same booking id', () async {
    final id = await createId();
    final first =
        await AppDependencies.bookingFlow.getOrCreateBookingViewModel(id);
    final second =
        await AppDependencies.bookingFlow.getOrCreateBookingViewModel(id);
    expect((first as AppSuccess).data, same((second as AppSuccess).data));
  });
}
