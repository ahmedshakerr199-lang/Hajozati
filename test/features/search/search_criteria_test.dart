import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/features/search/domain/search_models.dart';
import 'package:hajozati/features/search/domain/search_use_cases.dart';

void main() {
  final search = SearchHotelsUseCase(AppDependencies.search);
  Future<List<String>> ids(String provinceId) async =>
      (await search(SearchQuery(filter: SearchFilter(provinceId: provinceId))))
          .hotels
          .map((hotel) => hotel.province.id)
          .toList();

  test('Baghdad criteria returns Baghdad hotels only', () async {
    final provinces = await ids('baghdad');
    expect(provinces, isNotEmpty);
    expect(provinces.every((id) => id == 'baghdad'), isTrue);
  });

  test('Basra criteria returns Basra hotels only', () async {
    final provinces = await ids('basra');
    expect(provinces, isNotEmpty);
    expect(provinces.every((id) => id == 'basra'), isTrue);
  });

  test('province with no hotel returns an empty result', () async {
    expect(await ids('no-catalog-hotels'), isEmpty);
  });
}
