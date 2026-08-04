import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/search/data/mock_search_repository.dart';
import 'package:hajozati/features/search/domain/search_models.dart';
import 'package:hajozati/features/hotels/data/repositories/mock_hotel_repository.dart';

void main() {
  final repo = MockSearchRepository(MockHotelRepository());
  test('Arabic normalization and suggestions work', () async {
    final result = await repo.search(const SearchQuery(text: 'فندق'));
    expect(result.hotels, isNotEmpty);
    expect(await repo.suggestions(''), isNotEmpty);
  });
  test('recent searches are limited', () async {
    for (var i = 0; i < 11; i++) {
      await repo.saveRecent('q$i');
    }
    expect(await repo.recentSearches(), hasLength(10));
  });
}
