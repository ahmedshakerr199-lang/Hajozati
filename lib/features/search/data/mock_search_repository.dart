import '../../hotels/domain/repositories/hotel_repository.dart';
import '../domain/search_models.dart';
import '../domain/search_repository.dart';

class MockSearchRepository implements SearchRepository {
  MockSearchRepository(this._hotels);
  final HotelRepository _hotels;
  final List<String> _recent = [];
  @override
  Future<SearchResult> search(SearchQuery query) async {
    var list = await _hotels.watchHotels().first;
    final text = _normalize(query.text);
    if (text.isNotEmpty) {
      list = list
          .where((h) => _normalize(
                  '${h.nameAr} ${h.cityAr} ${h.province.nameAr} ${h.province.nameEn}')
              .contains(text))
          .toList();
    }
    final f = query.filter;
    if (f.provinceId != null) {
      list = list.where((h) => h.province.id == f.provinceId).toList();
    }
    if (f.minimumStars != null) {
      list = list.where((h) => h.stars >= f.minimumStars!).toList();
    }
    if (f.minimumRating != null) {
      list = list.where((h) => h.rating >= f.minimumRating!).toList();
    }
    if (f.priceRange != null) {
      list = list
          .where((h) =>
              h.minimumPricePerNight >= f.priceRange!.minimum &&
              h.minimumPricePerNight <= f.priceRange!.maximum)
          .toList();
    }
    if (f.discountsOnly) {
      list = list.where((h) => h.discountPercentage != null).toList();
    }
    list.sort((a, b) => switch (query.sort) {
          SortOption.lowestPrice =>
            a.minimumPricePerNight.compareTo(b.minimumPricePerNight),
          SortOption.highestPrice =>
            b.minimumPricePerNight.compareTo(a.minimumPricePerNight),
          SortOption.highestRated => b.rating.compareTo(a.rating),
          SortOption.mostPopular => b.reviewsCount.compareTo(a.reviewsCount),
          _ => a.nameAr.compareTo(b.nameAr)
        });
    return SearchResult(List.unmodifiable(list));
  }

  @override
  Future<List<String>> suggestions(String query) async => const [
        'فنادق بغداد',
        'فنادق البصرة',
        'فنادق النجف',
        'فنادق خمس نجوم',
        'فنادق قريبة مني',
        'فنادق مناسبة للعائلات'
      ];
  @override
  Future<void> clearRecent() async => _recent.clear();
  @override
  Future<List<String>> recentSearches() async => List.unmodifiable(_recent);
  @override
  Future<void> saveRecent(String query) async {
    if (query.trim().isEmpty) {
      return;
    }
    _recent.remove(query);
    _recent.insert(0, query);
    if (_recent.length > 10) {
      _recent.removeLast();
    }
  }

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp('[ًٌٍَُِّْ]'), '');
}
