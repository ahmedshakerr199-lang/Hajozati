import '../../../../core/result/app_result.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../entities/tourist_destination.dart';

/// Read-only destination catalog boundary.
abstract interface class ExploreIraqRepository {
  Stream<List<TouristDestination>> observeDestinations();
  Stream<List<TouristDestination>> observeFeaturedDestinations();
  Stream<List<TouristDestination>> observePopularDestinations();
  Future<AppResult<List<TouristDestination>>> searchDestinations(String query);
  Future<AppResult<List<TouristDestination>>> destinationsByCategory(
      DestinationCategory category);
  Future<AppResult<TouristDestination>> getDestinationById(String id);
  Future<AppResult<List<TouristDestination>>> similarDestinations(String id);
  Future<AppResult<List<Hotel>>> hotelsNearDestination(String id);
}
