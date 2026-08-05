import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/result/app_result.dart';
import '../../../booking/presentation/booking_view_model.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/hajozati_components.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../viewmodels/hotel_details_view_model.dart';

class HotelDetailsPage extends StatefulWidget {
  const HotelDetailsPage(
      {super.key, required this.hotelId, required this.repository});
  final String hotelId;
  final HotelRepository repository;
  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late final HotelDetailsViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = HotelDetailsViewModel(widget.repository, widget.hotelId)..load();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: vm,
        builder: (_, __) => Scaffold(body: _body()),
      );
  Widget _body() {
    final state = vm.state;
    if (state is HotelDetailsLoading) {
      return const Scaffold(body: HajozatiStateView.loading());
    }
    if (state is HotelDetailsEmpty) {
      return const Scaffold(
          body: HajozatiStateView.empty(message: 'الفندق غير موجود'));
    }
    if (state is HotelDetailsError) {
      return Scaffold(
          body: HajozatiStateView.error(
              message: state.message, onAction: vm.load));
    }
    final success = state as HotelDetailsSuccess;
    final hotel = success.hotel;
    return Scaffold(
        body: Stack(children: [
      ListView(padding: const EdgeInsets.fromLTRB(0, 0, 0, 100), children: [
        SizedBox(
            height: 290,
            child: Stack(fit: StackFit.expand, children: [
              HajozatiNetworkImage(
                  url: hotel.coverImageUrl, fit: BoxFit.cover, borderRadius: 0),
              Positioned(
                  top: 48,
                  right: 16,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_forward_ios_rounded,
                              size: 18)))),
              const Positioned(
                  top: 48,
                  left: 16,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite_border_rounded)))
            ])),
        Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(hotel.nameAr,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.warning),
                    Text(
                        ' ${hotel.rating.toStringAsFixed(1)} (${hotel.reviewsCount} مراجعة)'),
                    Text('${hotel.stars} نجوم',
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800))
                  ]),
              const SizedBox(height: 6),
              Text('${hotel.addressAr}، ${hotel.province.nameAr}',
                  style: const TextStyle(color: AppColors.muted)),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'عن الفندق'),
              Text(hotel.descriptionAr),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'المرافق'),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hotel.amenities
                      .map((item) => Chip(
                          avatar:
                              const Icon(Icons.check_circle_outline, size: 16),
                          label: Text(item.name)))
                      .toList()),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'الغرف المتاحة'),
              ...hotel.roomTypes.map((room) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HajozatiCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: [
                          const Icon(Icons.bed_rounded,
                              color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(room.nameAr,
                                  maxLines: 1, overflow: TextOverflow.ellipsis))
                        ]),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${room.pricePerNight} د.ع / ليلة',
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w800))
                      ])))),
              if (success.similar.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'فنادق مشابهة'),
                ...success.similar.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: HotelPreviewCard(
                        name: item.nameAr,
                        location: item.province.nameAr,
                        price: '${item.minimumPricePerNight} د.ع',
                        rating: item.rating,
                        imageUrl: item.coverImageUrl,
                        onTap: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.hotelDetails,
                            arguments: item.id))))
              ]
            ]))
      ]),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
              top: false,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: FilledButton(
                      onPressed: () async {
                        final result = await AppDependencies.bookingFlow
                            .createDraftForHotel(hotel.id);
                        if (!mounted) return;
                        switch (result) {
                          case AppSuccess<BookingViewModel>(
                              data: final viewModel
                            ):
                            final bookingId = viewModel.booking?.id;
                            if (bookingId == null || bookingId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('تعذر إنشاء مسودة الحجز.')));
                              return;
                            }
                            Navigator.pushNamed(
                                context, AppRoutes.roomSelection,
                                arguments: bookingId);
                          case AppFailure<BookingViewModel>(error: final error):
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.message)));
                        }
                      },
                      child: const Text('احجز الآن')))))
    ]));
  }
}
