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
    if (normalized.isEmpty) return const AppSuccess(MockDestinations.data);
    return AppSuccess(MockDestinations.data
        .where((item) => '${item.nameAr} ${item.nameEn} ${item.cityAr}'
            .toLowerCase()
            .contains(normalized))
        .toList(growable: false));
  }

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
    return AppSuccess(hotels
        .where((hotel) => hotel.province.id == destination.provinceId)
        .toList(growable: false));
  }
}
