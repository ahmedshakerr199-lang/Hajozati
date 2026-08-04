import '../../hotels/domain/entities/hotel.dart';

enum SortOption {
  nearest,
  highestRated,
  lowestPrice,
  highestPrice,
  mostPopular,
  newest
}

class PriceRange {
  const PriceRange(this.minimum, this.maximum);
  final int minimum, maximum;
}

class SearchFilter {
  const SearchFilter(
      {this.provinceId,
      this.priceRange,
      this.minimumStars,
      this.minimumRating,
      this.amenities = const [],
      this.category,
      this.familyFriendly = false,
      this.discountsOnly = false});
  final String? provinceId;
  final PriceRange? priceRange;
  final int? minimumStars;
  final double? minimumRating;
  final List<HotelAmenity> amenities;
  final HotelCategory? category;
  final bool familyFriendly, discountsOnly;
}

class SearchQuery {
  const SearchQuery(
      {this.text = '',
      this.filter = const SearchFilter(),
      this.sort = SortOption.highestRated});
  final String text;
  final SearchFilter filter;
  final SortOption sort;
}

class SearchResult {
  const SearchResult(this.hotels);
  final List<Hotel> hotels;
}
