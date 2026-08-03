import 'province.dart';

enum HotelCategory { hotel, resort, apartment, hotelApartment, guestHouse, chalet, motel, hostel }
enum HotelAmenity { wifi, parking, pool, restaurant, gym, roomService, reception24h, airConditioning, elevator, airportShuttle, familyFriendly, generator, housekeeping, accessible }
enum RoomAmenity { privateBathroom, wifi, tv, airConditioning, balcony, safe }

class HotelPolicies {
  const HotelPolicies({required this.checkInFrom, required this.checkOutUntil, required this.childrenAllowed, required this.petsAllowed, required this.smokingAllowed, required this.cancellationSummary});
  final String checkInFrom, checkOutUntil, cancellationSummary;
  final bool childrenAllowed, petsAllowed, smokingAllowed;
}
class RoomType {
  const RoomType({required this.id,required this.nameAr,required this.descriptionAr,required this.capacityAdults,required this.capacityChildren,required this.pricePerNight,required this.availableRooms,required this.amenities,required this.refundable,required this.breakfastIncluded});
  final String id,nameAr,descriptionAr; final int capacityAdults,capacityChildren,pricePerNight,availableRooms; final List<RoomAmenity> amenities; final bool refundable,breakfastIncluded;
}
class Hotel {
  const Hotel({required this.id,required this.nameAr,required this.province,required this.cityAr,required this.addressAr,required this.rating,required this.stars,required this.reviewsCount,required this.minimumPricePerNight,required this.category,required this.isFeatured,required this.isRecommended,required this.isPopular,required this.descriptionAr,required this.imageUrls,required this.amenities,required this.roomTypes,required this.policies,this.isFavorite=false,this.discountPercentage});
  final String id,nameAr,cityAr,addressAr,descriptionAr; final Province province; final double rating; final int stars,reviewsCount,minimumPricePerNight; final HotelCategory category; final bool isFeatured,isRecommended,isPopular,isFavorite; final int? discountPercentage; final List<String> imageUrls; final List<HotelAmenity> amenities; final List<RoomType> roomTypes; final HotelPolicies policies;
  String get coverImageUrl => imageUrls.first;
  Hotel copyWith({bool? isFavorite}) => Hotel(id:id,nameAr:nameAr,province:province,cityAr:cityAr,addressAr:addressAr,rating:rating,stars:stars,reviewsCount:reviewsCount,minimumPricePerNight:minimumPricePerNight,category:category,isFeatured:isFeatured,isRecommended:isRecommended,isPopular:isPopular,descriptionAr:descriptionAr,imageUrls:imageUrls,amenities:amenities,roomTypes:roomTypes,policies:policies,isFavorite:isFavorite??this.isFavorite,discountPercentage:discountPercentage);
}
