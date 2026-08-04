import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/result/app_result.dart';
import 'booking_view_model.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key, required this.bookingId});
  final String bookingId;
  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
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
                appBar: AppBar(title: const Text('تفاصيل الحجز')),
                body: ListView(padding: const EdgeInsets.all(16), children: [
                  Text('الليالي: ${vm.nights}'),
                  Text('الغرف: ${vm.rooms}'),
                  Text('البالغون: ${vm.adults}'),
                  Text('الأطفال: ${vm.children}'),
                  ...vm.validationMessages.map(Text.new),
                  FilledButton(
                      onPressed: vm.validateBooking,
                      child: const Text('متابعة'))
                ]));
          });
}
