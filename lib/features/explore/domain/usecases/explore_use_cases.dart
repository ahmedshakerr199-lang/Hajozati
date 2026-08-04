import '../../../../core/result/app_result.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../entities/tourist_destination.dart';
import '../repositories/explore_iraq_repository.dart';

class GetDestinationsUseCase {
  const GetDestinationsUseCase(this.repository);
  final ExploreIraqRepository repository;
  Stream<List<TouristDestination>> call() => repository.observeDestinations();
}

class GetFeaturedDestinationsUseCase {
  const GetFeaturedDestinationsUseCase(this.repository);
  final ExploreIraqRepository repository;
  Stream<List<TouristDestination>> call() =>
      repository.observeFeaturedDestinations();
}

class GetPopularDestinationsUseCase {
  const GetPopularDestinationsUseCase(this.repository);
  final ExploreIraqRepository repository;
  Stream<List<TouristDestination>> call() =>
      repository.observePopularDestinations();
}

class SearchDestinationsUseCase {
  const SearchDestinationsUseCase(this.repository);
  final ExploreIraqRepository repository;
  Future<AppResult<List<TouristDestination>>> call(String query) =>
      repository.searchDestinations(query);
}

class FilterDestinationsByProvinceUseCase {
  const FilterDestinationsByProvinceUseCase(this.repository);
  final ExploreIraqRepository repository;
  Future<AppResult<List<TouristDestination>>> call(String provinceId) =>
      repository.destinationsByProvince(provinceId);
}

class FilterDestinationsByCategoryUseCase {
  const FilterDestinationsByCategoryUseCase(this.repository);
  final ExploreIraqRepository repository;
  Future<AppResult<List<TouristDestination>>> call(
          DestinationCategory category) =>
      repository.destinationsByCategory(category);
}

class GetDestinationDetailsUseCase {
  const GetDestinationDetailsUseCase(this.repository);
  final ExploreIraqRepository repository;
  Future<AppResult<TouristDestination>> call(String id) =>
      repository.getDestinationById(id);
}

class GetSimilarDestinationsUseCase {
  const GetSimilarDestinationsUseCase(this.repository);
  final ExploreIraqRepository repository;
  Future<AppResult<List<TouristDestination>>> call(String id) =>
      repository.similarDestinations(id);
}

class GetHotelsNearDestinationUseCase {
  const GetHotelsNearDestinationUseCase(this.repository);
  final ExploreIraqRepository repository;
  Future<AppResult<List<Hotel>>> call(String id) =>
      repository.hotelsNearDestination(id);
}
