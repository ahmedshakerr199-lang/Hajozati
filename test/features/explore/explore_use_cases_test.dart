import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/features/explore/data/repositories/mock_explore_repository.dart';
import 'package:hajozati/features/explore/domain/entities/tourist_destination.dart';
import 'package:hajozati/features/explore/domain/usecases/explore_use_cases.dart';
import 'package:hajozati/features/hotels/data/repositories/mock_hotel_repository.dart';

void main() {
  final repo = MockExploreRepository(MockHotelRepository());
  test('filters destinations by category', () async {
    final result = await FilterDestinationsByCategoryUseCase(repo)(
        DestinationCategory.museum);
    expect((result as AppSuccess).data, isNotEmpty);
  });
  test('nearby destination hotels are returned', () async {
    final result = await GetHotelsNearDestinationUseCase(repo)('ur-ziggurat');
    expect((result as AppSuccess).data, isNotEmpty);
  });
}
