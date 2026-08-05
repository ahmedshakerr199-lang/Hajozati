import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/hajozati_components.dart';
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
          return const Scaffold(body: HajozatiStateView.loading());
        }
        if (vm.state != BookingConfirmationState.success) {
          return Scaffold(
              body: HajozatiStateView.error(
                  message: vm.error ?? 'تعذر تحميل الحجز المؤكد.'));
        }
        final b = vm.confirmedBooking!;
        return Scaffold(
            body: SafeArea(
                child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.page),
                    children: [
              const SizedBox(height: AppSpacing.lg),
              const CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFFE4F5EA),
                  child: Icon(Icons.check_rounded,
                      color: AppColors.success, size: 54)),
              const SizedBox(height: AppSpacing.md),
              Text('تم تأكيد الحجز بنجاح',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              const Text('نتمنى لك إقامة مريحة وممتعة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: AppSpacing.lg),
              HajozatiCard(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('رقم الحجز',
                        style: TextStyle(color: AppColors.muted)),
                    Text(b.number ?? 'BK-MOCK',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 22,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800)),
                    const Divider(),
                    Text('الفندق: ${b.hotelId}'),
                    Text('الوصول: ${b.checkIn}'),
                    Text('المغادرة: ${b.checkOut}'),
                    Text('الليالي: ${b.nights}'),
                    Text('الضيوف: ${b.guests.total}'),
                    const Text('الإجمالي محفوظ ضمن تفاصيل الحجز',
                        style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800))
                  ])),
              const SizedBox(height: AppSpacing.md),
              const HajozatiCard(
                  child: Column(children: [
                Icon(Icons.qr_code_2_rounded,
                    size: 42, color: AppColors.primary),
                SizedBox(height: 8),
                Text('QR Code — Coming Soon', textAlign: TextAlign.center)
              ])),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('العودة للرئيسية')),
              OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('الميزة ستكون متاحة قريبًا.'))),
                  child: const Text('عرض حجوزاتي'))
            ])));
      });
}
