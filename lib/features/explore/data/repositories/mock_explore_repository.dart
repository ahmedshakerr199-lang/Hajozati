import 'dart:math';
import '../../../../core/result/app_result.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../../../hotels/domain/repositories/hotel_repository.dart';
import '../../domain/entities/tourist_destination.dart';
import '../../domain/repositories/explore_iraq_repository.dart';
import '../datasources/mock_destinations.dart';

/// In-memory implementation that mirrors the eventual remote repository contract.
class MockExploreRepository implements ExploreIraqRepository {
  MockExploreRepository(this._hotels);
  final HotelRepository _hotels;

  @override
  Stream<List<TouristDestination>> observeDestinations() =>
      Stream.value(MockDestinations.data);
  @override
  Stream<List<TouristDestination>> observeFeaturedDestinations() =>
      Stream.value(MockDestinations.data
          .where((item) => item.isFeatured)
          .toList(growable: false));
  @override
  Stream<List<TouristDestination>> observePopularDestinations() =>
      Stream.value(MockDestinations.data
          .where((item) => item.isPopular)
          .toList(growable: false));

  @override
  Future<AppResult<List<TouristDestination>>> searchDestinations(
      String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return AppSuccess(MockDestinations.data);
    return AppSuccess(MockDestinations.data
        .where((item) => '${item.nameAr} ${item.nameEn} ${item.cityAr}'
            .toLowerCase()
            .contains(normalized))
        .toList(growable: false));
  }

  @override
  Future<AppResult<List<TouristDestination>>> destinationsByProvince(
          String provinceId) async =>
      AppSuccess(MockDestinations.data
          .where((item) => item.provinceId == provinceId)
          .toList(growable: false));

  @override
  Future<AppResult<List<TouristDestination>>> destinationsByCategory(
          DestinationCategory category) async =>
      AppSuccess(MockDestinations.data
          .where((item) => item.category == category)
          .toList(growable: false));

  @override
  Future<AppResult<TouristDestination>> getDestinationById(String id) async {
    for (final item in MockDestinations.data) {
      if (item.id == id) return AppSuccess(item);
    }
    return const AppFailure(NotFoundAppError('لم يتم العثور على الوجهة.'));
  }

  @override
  Future<AppResult<List<TouristDestination>>> similarDestinations(
      String id) async {
    final result = await getDestinationById(id);
    if (result case AppFailure(error: final error)) return AppFailure(error);
    final destination = (result as AppSuccess<TouristDestination>).data;
    return AppSuccess(MockDestinations.data
        .where((item) =>
            item.id != id && item.provinceId == destination.provinceId)
        .toList(growable: false));
  }

  @override
  Future<AppResult<List<Hotel>>> hotelsNearDestination(String id) async {
    final result = await getDestinationById(id);
    if (result case AppFailure(error: final error)) return AppFailure(error);
    final destination = (result as AppSuccess<TouristDestination>).data;
    final hotels = await _hotels.watchHotels().first;
    final nearby = hotels.where((hotel) => hotel.hasValidCoordinates).toList()
      ..sort((a, b) => _distance(destination.latitude, destination.longitude,
              a.latitude, a.longitude)
          .compareTo(_distance(destination.latitude, destination.longitude,
              b.latitude, b.longitude)));
    return AppSuccess(nearby.take(8).toList(growable: false));
  }

  double _distance(double aLat, double aLng, double bLat, double bLng) {
    const radius = 6371.0;
    final dLat = (bLat - aLat) * pi / 180;
    final dLng = (bLng - aLng) * pi / 180;
    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(aLat * pi / 180) *
            cos(bLat * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return 2 * radius * atan2(sqrt(h), sqrt(1 - h));
  }
}
