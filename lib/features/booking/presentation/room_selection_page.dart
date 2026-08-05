import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../core/result/app_result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/navigation/app_routes.dart';
import '../../hotels/domain/entities/hotel.dart';
import '../domain/booking_models.dart';
import 'booking_view_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/hajozati_components.dart';

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({super.key, required this.bookingId});
  final String bookingId;
  @override
  State<RoomSelectionPage> createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  late Future<AppResult<BookingViewModel>> _flow;
  late final Future<Hotel?> _hotel;

  @override
  void initState() {
    super.initState();
    _flow = AppDependencies.bookingFlow
        .getOrCreateBookingViewModel(widget.bookingId);
    _hotel = _flow.then<Hotel?>((result) async {
      if (result case AppSuccess(data: final viewModel)) {
        final hotelId = viewModel.booking?.hotelId;
        if (hotelId != null && hotelId.isNotEmpty) {
          return AppDependencies.hotels.getHotelById(hotelId);
        }
      }
      return null;
    });
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
            appBar: AppBar(title: const Text('اختيار الغرفة')),
            body: FutureBuilder(
                future: _hotel,
                builder: (_, hotelSnapshot) {
                  if (!hotelSnapshot.hasData) {
                    return const HajozatiStateView.loading();
                  }
                  final hotel = hotelSnapshot.data;
                  if (hotel == null) {
                    return const HajozatiStateView.empty(
                        message: 'الفندق غير موجود.');
                  }
                  if (hotel.roomTypes.isEmpty) {
                    return const HajozatiStateView.empty(
                        message: 'لا توجد غرف متاحة لهذا الفندق.');
                  }
                  return ListView(
                      padding: const EdgeInsets.all(AppSpacing.page),
                      children: [
                        Text(hotel.nameAr,
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        const Text('اختر الغرفة الأنسب لإقامتك'),
                        const SizedBox(height: AppSpacing.lg),
                        ...hotel.roomTypes.map((type) {
                          final selected =
                              vm.selectedRoom?.roomType.id == type.id;
                          return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: HajozatiCard(
                                color: selected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : null,
                                onTap: () async {
                                  await vm.selectRoom(
                                      BookingRoom(roomType: type, quantity: 1));
                                  await vm.calculatePrice();
                                  if (!context.mounted) {
                                    return;
                                  }
                                  setState(() {});
                                  Navigator.pushNamed(
                                      context, AppRoutes.bookingDetails,
                                      arguments: widget.bookingId);
                                },
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        const Icon(Icons.bed_rounded,
                                            color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(type.nameAr,
                                                style: const TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontWeight:
                                                        FontWeight.w800))),
                                        if (selected)
                                          const Icon(Icons.check_circle_rounded,
                                              color: AppColors.success)
                                      ]),
                                      const SizedBox(height: 8),
                                      Text(
                                          'السعة: ${type.capacityAdults} بالغين · المتاح: ${type.availableRooms}'),
                                      Text(
                                          type.breakfastIncluded
                                              ? 'الإفطار متضمن'
                                              : 'الإفطار غير متضمن',
                                          style: const TextStyle(
                                              color: AppColors.muted)),
                                      const SizedBox(height: 10),
                                      Text('${type.pricePerNight} د.ع / ليلة',
                                          style: const TextStyle(
                                              color: AppColors.accent,
                                              fontWeight: FontWeight.w800))
                                    ]),
                              ));
                        })
                      ]);
                }));
      });
}
