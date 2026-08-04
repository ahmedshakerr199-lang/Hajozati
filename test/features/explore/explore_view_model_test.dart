import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/explore/data/repositories/mock_explore_repository.dart';
import 'package:hajozati/features/explore/domain/usecases/explore_use_cases.dart';
import 'package:hajozati/features/explore/presentation/viewmodels/explore_view_model.dart';
import 'package:hajozati/features/hotels/data/repositories/mock_hotel_repository.dart';

void main() {
  test('view model loads destinations', () async {
    final repo = MockExploreRepository(MockHotelRepository());
    final vm = ExploreViewModel(
        GetDestinationsUseCase(repo),
        GetFeaturedDestinationsUseCase(repo),
        GetPopularDestinationsUseCase(repo),
        SearchDestinationsUseCase(repo),
        FilterDestinationsByProvinceUseCase(repo),
        FilterDestinationsByCategoryUseCase(repo));
    await vm.load();
    expect(vm.destinations, isNotEmpty);
    vm.dispose();
  });
}
