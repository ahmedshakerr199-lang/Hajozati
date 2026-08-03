import 'province.dart';

enum HotelCategory { hotel, resort, apartment, hotelApartment, guestHouse, chalet, motel, hostel }
enum HotelAmenity { wifi, parking, pool, restaurant, gym, spa, roomService, reception24h, airConditioning, elevator, airportShuttle, familyFriendly, generator, housekeeping, accessible }

class Hotel {
  const Hotel({required this.id, required this.nameAr, required this.province, required this.cityAr, required this.addressAr, required this.rating, required this.stars, required this.reviewsCount, required this.minimumPricePerNight, required this.category, required this.isFeatured, required this.isRecommended, required this.isPopular, this.isFavorite = false, this.discountPercentage});
  final String id, nameAr, cityAr, addressAr;
  final Province province;
  final double rating;
  final int stars, reviewsCount;
  final int minimumPricePerNight;
  final HotelCategory category;
  final bool isFeatured, isRecommended, isPopular, isFavorite;
  final int? discountPercentage;
  Hotel copyWith({bool? isFavorite}) => Hotel(id:id,nameAr:nameAr,province:province,cityAr:cityAr,addressAr:addressAr,rating:rating,stars:stars,reviewsCount:reviewsCount,minimumPricePerNight:minimumPricePerNight,category:category,isFeatured:isFeatured,isRecommended:isRecommended,isPopular:isPopular,isFavorite:isFavorite ?? this.isFavorite,discountPercentage:discountPercentage);
}
