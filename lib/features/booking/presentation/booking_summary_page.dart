import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/result/app_result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/navigation/app_routes.dart';
import 'booking_view_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/hajozati_components.dart';

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
  Widget build(BuildContext context) => FutureBuilder<
          AppResult<BookingViewModel>>(
      future: _flow,
      builder: (_, s) {
        if (!s.hasData) {
          return const Scaffold(body: HajozatiStateView.loading());
        }
        if (s.data is AppFailure) {
          return const Scaffold(
              body:
                  HajozatiStateView.error(message: 'تعذر تحميل مسودة الحجز.'));
        }
        final vm = (s.data as AppSuccess<BookingViewModel>).data;
        return Scaffold(
            appBar: AppBar(title: const Text('ملخص الحجز')),
            body: ListView(
                padding: const EdgeInsets.all(AppSpacing.page),
                children: [
                  Text('راجع حجزك',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.lg),
                  HajozatiCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('ملخص الإقامة',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w800)),
                        const Divider(),
                        Text('الفندق: ${vm.booking?.hotelId ?? ''}'),
                        Text(
                            'الغرفة: ${vm.selectedRoom?.roomType.nameAr ?? 'لم يتم الاختيار'}'),
                        Text('الليالي: ${vm.nights}'),
                        Text('الضيوف: ${vm.adults + vm.children}')
                      ])),
                  const SizedBox(height: AppSpacing.md),
                  HajozatiCard(
                      child: Column(children: [
                    _price('المجموع الفرعي', vm.subtotal),
                    _price('الضرائب', vm.taxes),
                    _price('الخصم', -vm.discount),
                    const Divider(),
                    _price('الإجمالي', vm.grandTotal, emphasized: true)
                  ])),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                      onPressed: () async {
                        await vm.confirmBooking();
                        if (!context.mounted) return;
                        if (vm.state == BookingViewState.confirmed) {
                          await AppDependencies.bookingFlow
                              .releaseBookingFlow(widget.bookingId);
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.bookingConfirmation,
                              arguments: widget.bookingId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(vm.error ?? 'تعذر تأكيد الحجز.')));
                        }
                      },
                      child: const Text('تأكيد الحجز'))
                ]));
      });

  Widget _price(String label, int amount, {bool emphasized = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(
            child: Text(label,
                style: emphasized
                    ? const TextStyle(
                        fontFamily: 'Cairo', fontWeight: FontWeight.w800)
                    : null)),
        Text('$amount د.ع',
            style: TextStyle(
                color: emphasized ? AppColors.accent : AppColors.text,
                fontWeight: FontWeight.w800))
      ]));
}
