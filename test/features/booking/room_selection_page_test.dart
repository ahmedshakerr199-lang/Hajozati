import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/booking/domain/booking_models.dart';
import 'package:hajozati/features/booking/presentation/room_selection_page.dart';
import 'package:hajozati/features/hotels/domain/entities/hotel.dart';
import 'booking_ui_test_helper.dart';

void main() {
  testWidgets('shows a room price and capacity', (t) async {
    final vm = createBookingViewModel();
    await vm.initializeBooking('hotel');
    const room = RoomType(
        id: 'r',
        nameAr: 'قياسية',
        descriptionAr: '',
        capacityAdults: 2,
        capacityChildren: 0,
        pricePerNight: 100000,
        availableRooms: 2,
        amenities: [],
        refundable: true,
        breakfastIncluded: true);
    await t.pumpWidget(MaterialApp(
        home: RoomSelectionPage(
            viewModel: vm,
            rooms: const [BookingRoom(roomType: room, quantity: 1)])));
    expect(find.text('قياسية'), findsOneWidget);
    expect(find.textContaining('100000'), findsOneWidget);
  });
}
