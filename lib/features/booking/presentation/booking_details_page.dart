import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/result/app_result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/navigation/app_routes.dart';
import 'booking_view_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/hajozati_components.dart';

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
            appBar: AppBar(title: const Text('تفاصيل الحجز')),
            body: ListView(
                padding: const EdgeInsets.all(AppSpacing.page),
                children: [
                  Text('تفاصيل إقامتك',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.lg),
                  HajozatiCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('ملخص سريع',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w800)),
                        const Divider(),
                        _detail(Icons.calendar_month_rounded, 'عدد الليالي',
                            '${vm.nights} ليالٍ'),
                        _detail(Icons.meeting_room_rounded, 'عدد الغرف',
                            '${vm.rooms}'),
                        _detail(
                            Icons.person_rounded, 'البالغون', '${vm.adults}'),
                        _detail(Icons.child_care_rounded, 'الأطفال',
                            '${vm.children}')
                      ])),
                  if (vm.validationMessages.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    HajozatiCard(
                        color: const Color(0xFFFFE9E9),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: vm.validationMessages
                                .map((message) => Text('• $message',
                                    style: const TextStyle(
                                        color: Color(0xFFD63B3B))))
                                .toList()))
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                      onPressed: () async {
                        await vm.validateBooking();
                        if (vm.state == BookingViewState.readyForConfirmation &&
                            context.mounted) {
                          Navigator.pushNamed(context, AppRoutes.bookingSummary,
                              arguments: widget.bookingId);
                        }
                      },
                      child: const Text('متابعة'))
                ]));
      });

  Widget _detail(IconData icon, String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 19),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700))
      ]));
}
