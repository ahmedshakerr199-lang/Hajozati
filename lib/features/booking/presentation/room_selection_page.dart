import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/result/app_result.dart';
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
                body: Center(
                    child: vm.selectedRoom == null
                        ? const Text(
                            'اختر غرفة من بيانات الفندق في الخطوة التالية.')
                        : Text(vm.selectedRoom!.roomType.nameAr)));
          });
}
