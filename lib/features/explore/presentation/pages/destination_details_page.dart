import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/result/app_result.dart';
import '../../../nearby/domain/nearby_hotels.dart';
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
  List<NearbyHotel> _nearbyHotels = const [];

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
        final distance = CalculateDistanceUseCase();
        _nearbyHotels = data
            .map((hotel) => NearbyHotel(
                hotel,
                distance(
                    UserLocation(destination.latitude, destination.longitude),
                    hotel.latitude,
                    hotel.longitude)))
            .toList();
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
    if (result == null)
      return const Scaffold(body: Center(child: _DetailsSkeleton()));
    if (result is AppFailure<TouristDestination>) {
      final notFound = result.error is NotFoundAppError;
      return Scaffold(
          appBar: AppBar(),
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(notFound ? Icons.search_off : Icons.error_outline, size: 48),
            Text(notFound ? 'الوجهة غير موجودة' : result.error.message),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('إعادة المحاولة'))
          ])));
    }
    final item = (result as AppSuccess<TouristDestination>).data;
    return Scaffold(
        appBar: AppBar(title: Text(item.nameAr)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Hero(
              tag: 'destination-${item.id}',
              child: AspectRatio(
                  aspectRatio: 1.6,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(item.coverImageUrl,
                          fit: BoxFit.cover)))),
          const SizedBox(height: 12),
          Text(item.nameAr, style: Theme.of(context).textTheme.headlineSmall),
          Text('${item.cityAr}، ${item.addressAr}'),
          Chip(label: Text(_categoryName(item.category))),
          const SizedBox(height: 8),
          Text(item.descriptionAr),
          if (item.imageUrls.length > 1) ...[
            const SizedBox(height: 16),
            const Text('معرض الصور'),
            SizedBox(
                height: 92,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.imageUrls.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(item.imageUrls[index],
                            width: 130, fit: BoxFit.cover))))
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
          const Card(
              child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                      'ساعات الزيارة والأسعار بيانات تجريبية وتحتاج إلى تحقق قبل الزيارة.'))),
          const ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('الموقع'),
              subtitle: Text('خريطة OpenStreetMap ستكون متاحة قريبًا')),
          const SizedBox(height: 12),
          const Text('الفنادق القريبة من الوجهة'),
          ..._nearbyHotels.map((entry) => ListTile(
              onTap: () => Navigator.pushNamed(context, AppRoutes.hotelDetails,
                  arguments: entry.hotel.id),
              leading: const Icon(Icons.hotel),
              title: Text(entry.hotel.nameAr),
              subtitle: Text(entry.distanceKm < 1
                  ? '${(entry.distanceKm * 1000).round()} م'
                  : '${entry.distanceKm.toStringAsFixed(1)} كم'))),
          if (_nearbyHotels.isEmpty)
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

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          children: List.generate(
              5,
              (_) => Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8))))));
}
