import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/result/app_result.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/hajozati_components.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../../domain/entities/tourist_destination.dart';
import '../../domain/usecases/explore_use_cases.dart';

/// Shows a destination and catalog hotels ordered by distance from that destination.
class DestinationDetailsPage extends StatefulWidget {
  const DestinationDetailsPage({super.key, required this.destinationId});
  final String destinationId;
  @override
  State<DestinationDetailsPage> createState() => _DestinationDetailsPageState();
}

class _DestinationDetailsPageState extends State<DestinationDetailsPage> {
  AppResult<TouristDestination>? _result;
  List<TouristDestination> _similar = const [];
  List<Hotel> _destinationHotels = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _result = null);
    final details = await GetDestinationDetailsUseCase(AppDependencies.explore)(
        widget.destinationId);
    if (details case AppSuccess(data: final destination)) {
      final similar = await GetSimilarDestinationsUseCase(
          AppDependencies.explore)(destination.id);
      final hotels = await GetHotelsNearDestinationUseCase(
          AppDependencies.explore)(destination.id);
      if (hotels case AppSuccess(data: final data)) {
        _destinationHotels = data;
      }
      _similar = similar is AppSuccess<List<TouristDestination>>
          ? similar.data
          : const [];
    }
    if (mounted) setState(() => _result = details);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    if (result == null) {
      return const Scaffold(body: HajozatiStateView.loading());
    }
    if (result is AppFailure<TouristDestination>) {
      final notFound = result.error is NotFoundAppError;
      return Scaffold(
          appBar: AppBar(),
          body: HajozatiStateView.error(
              message: notFound ? 'الوجهة غير موجودة' : result.error.message,
              onAction: _load));
    }
    final item = (result as AppSuccess<TouristDestination>).data;
    return Scaffold(
        appBar: AppBar(title: Text(item.nameAr)),
        body:
            ListView(padding: const EdgeInsets.all(AppSpacing.page), children: [
          Hero(
              tag: 'destination-${item.id}',
              child: AspectRatio(
                  aspectRatio: 1.6,
                  child: HajozatiNetworkImage(
                      url: item.coverImageUrl,
                      fit: BoxFit.cover,
                      borderRadius: 20))),
          const SizedBox(height: AppSpacing.md),
          Text(item.nameAr, style: Theme.of(context).textTheme.headlineSmall),
          Text('${item.cityAr}، ${item.addressAr}'),
          Chip(label: Text(_categoryName(item.category))),
          const SizedBox(height: AppSpacing.sm),
          Text(item.descriptionAr),
          if (item.imageUrls.length > 1) ...[
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'معرض الصور'),
            SizedBox(
                height: 92,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.imageUrls.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: HajozatiNetworkImage(
                            url: item.imageUrls[index], fit: BoxFit.cover))))
          ],
          if (item.suggestedVisitHours != null)
            ListTile(
                leading: const Icon(Icons.timelapse),
                title: Text(
                    'مدة الزيارة المقترحة: ${item.suggestedVisitHours} ساعة')),
          if (item.openingHoursAr != null)
            ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(item.openingHoursAr!)),
          if (!item.entryIsFree)
            ListTile(
                leading: const Icon(Icons.confirmation_number_outlined),
                title: Text('رسوم الدخول: ${item.entryPriceIqd} د.ع')),
          const HajozatiCard(
              child: Text(
                  'ساعات الزيارة والأسعار بيانات تجريبية وتحتاج إلى تحقق قبل الزيارة.')),
          const ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('الموقع'),
              subtitle: Text('خريطة OpenStreetMap ستكون متاحة قريبًا')),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'الفنادق القريبة من الوجهة'),
          ..._destinationHotels.map((hotel) => HajozatiCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.hotelDetails,
                  arguments: hotel.id),
              child: ListTile(
                  leading: const Icon(Icons.hotel),
                  title: Text(hotel.nameAr),
                  subtitle: Text(hotel.province.nameAr)))),
          if (_destinationHotels.isEmpty)
            const Text('لا توجد فنادق قريبة في البيانات التجريبية.'),
          if (_similar.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('وجهات مشابهة'),
            ..._similar.map((other) => ListTile(
                title: Text(other.nameAr),
                onTap: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.destinationDetails,
                    arguments: other.id)))
          ],
        ]));
  }

  String _categoryName(DestinationCategory value) => value.name;
}
