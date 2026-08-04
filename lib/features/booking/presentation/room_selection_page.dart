import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/result/app_result.dart';
import '../domain/booking_models.dart';
import 'booking_view_model.dart';

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({super.key, required this.bookingId});
  final String bookingId;
  @override
  State<RoomSelectionPage> createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  late Future<AppResult<BookingViewModel>> _flow;
  @override
  void initState() {
    super.initState();
    _flow = AppDependencies.bookingFlow
        .getOrCreateBookingViewModel(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<AppResult<BookingViewModel>>(
          future: _flow,
          builder: (_, s) {
            if (!s.hasData) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            if (s.data is AppFailure) {
              return const Scaffold(
                  body: Center(child: Text('تعذر تحميل مسودة الحجز.')));
            }
            final vm = (s.data as AppSuccess<BookingViewModel>).data;
            return Scaffold(
                appBar: AppBar(title: const Text('اختيار الغرفة')),
                body: FutureBuilder(
                    future: AppDependencies.hotels
                        .getHotelById(vm.booking!.hotelId),
                    builder: (_, hotelSnapshot) {
                      if (!hotelSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final hotel = hotelSnapshot.data;
                      if (hotel == null) {
                        return const Center(child: Text('الفندق غير موجود.'));
                      }
                      if (hotel.roomTypes.isEmpty) {
                        return const Center(child: Text('لا توجد غرف متاحة.'));
                      }
                      return ListView(
                          children: hotel.roomTypes.map((type) {
                        final selected =
                            vm.selectedRoom?.roomType.id == type.id;
                        return Card(
                            color: selected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            child: ListTile(
                                leading: const Icon(Icons.bed),
                                title: Text(type.nameAr),
                                subtitle: Text(
                                    'السعة ${type.capacityAdults} · المتاح ${type.availableRooms} · الإفطار ${type.breakfastIncluded ? 'متضمن' : 'غير متضمن'}'),
                                trailing: Text('${type.pricePerNight} د.ع'),
                                onTap: () async {
                                  await vm.selectRoom(
                                      BookingRoom(roomType: type, quantity: 1));
                                  await vm.calculatePrice();
                                  if (mounted) setState(() {});
                                }));
                      }).toList());
                    }));
          });
}
