import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/result/app_result.dart';
import 'booking_view_model.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key, required this.bookingId});
  final String bookingId;
  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
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
                appBar: AppBar(title: const Text('ملخص الحجز')),
                body: ListView(padding: const EdgeInsets.all(16), children: [
                  Text('الفندق: ${vm.booking?.hotelId ?? ''}'),
                  Text('الليالي: ${vm.nights}'),
                  Text('Grand Total: ${vm.grandTotal}'),
                  FilledButton(
                      onPressed: vm.confirmBooking,
                      child: const Text('تأكيد الحجز'))
                ]));
          });
}
