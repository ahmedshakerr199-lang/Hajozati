import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import 'booking_confirmation_view_model.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key, required this.bookingId});
  final String bookingId;
  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  late final BookingConfirmationViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = AppDependencies.createBookingConfirmationViewModel(widget.bookingId)
      ..load();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: vm,
      builder: (_, __) {
        if (vm.state == BookingConfirmationState.initial ||
            vm.state == BookingConfirmationState.loading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (vm.state != BookingConfirmationState.success) {
          return Scaffold(
              body:
                  Center(child: Text(vm.error ?? 'تعذر تحميل الحجز المؤكد.')));
        }
        final b = vm.confirmedBooking!;
        return Scaffold(
            body: SafeArea(
                child: Center(
                    child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(24),
                        children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const Text('تم تأكيد الحجز بنجاح', textAlign: TextAlign.center),
              Text('رقم الحجز: ${b.number ?? 'Mock'}'),
              Text('الفندق: ${b.hotelId}'),
              Text('الوصول: ${b.checkIn}'),
              Text('المغادرة: ${b.checkOut}'),
              Text('الليالي: ${b.nights}'),
              Text('الضيوف: ${b.guests.total}'),
              const Card(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('QR Code — Coming Soon',
                          textAlign: TextAlign.center))),
              FilledButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('العودة للرئيسية')),
              OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('الميزة ستكون متاحة قريبًا.'))),
                  child: const Text('عرض حجوزاتي'))
            ]))));
      });
}
