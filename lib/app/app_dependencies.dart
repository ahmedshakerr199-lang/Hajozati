import '../core/location/geolocator_location_service.dart';
import '../core/location/location_service.dart';
import '../features/explore/data/repositories/mock_explore_repository.dart';
import '../features/explore/domain/repositories/explore_iraq_repository.dart';
import '../features/hotels/data/repositories/mock_hotel_repository.dart';
import '../features/hotels/domain/repositories/hotel_repository.dart';

/// Composition root. Widgets receive view models or route ids, never mock data sources.
class AppDependencies {
  AppDependencies._();

  static final HotelRepository hotels = MockHotelRepository();
  static final ExploreIraqRepository explore = MockExploreRepository(hotels);
  static final LocationService location = GeolocatorLocationService();
}
