import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/features/explore/data/repositories/mock_explore_repository.dart';
import 'package:hajozati/features/hotels/data/repositories/mock_hotel_repository.dart';

void main() {
  final repository = MockExploreRepository(MockHotelRepository());
  test(
      'loads at least twenty destinations',
      () async => expect(await repository.observeDestinations().first,
          hasLength(greaterThanOrEqualTo(20))));
  test('search works in Arabic and English', () async {
    expect((await repository.searchDestinations('أور') as AppSuccess).data,
        isNotEmpty);
    expect((await repository.searchDestinations('Ur') as AppSuccess).data,
        isNotEmpty);
  });
  test(
      'missing destination returns failure',
      () async => expect(
          await repository.getDestinationById('missing'), isA<AppFailure>()));
}
