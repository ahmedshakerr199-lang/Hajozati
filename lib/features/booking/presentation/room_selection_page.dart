import 'package:flutter/material.dart';
import '../domain/booking_models.dart';
import 'booking_view_model.dart';

class RoomSelectionPage extends StatelessWidget {
  const RoomSelectionPage(
      {super.key, required this.viewModel, required this.rooms});
  final BookingViewModel viewModel;
  final List<BookingRoom> rooms;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('اختيار الغرفة')),
      body: ListView(
          children: rooms
              .map((room) => Card(
                  child: ListTile(
                      leading: const Icon(Icons.bed),
                      title: Text(room.roomType.nameAr),
                      subtitle: Text(
                          'السعة ${room.roomType.capacityAdults} · المتاح ${room.roomType.availableRooms}'),
                      trailing: FilledButton(
                          onPressed: () => viewModel.selectRoom(room),
                          child: Text('${room.roomType.pricePerNight} د.ع')))))
              .toList()));
}
