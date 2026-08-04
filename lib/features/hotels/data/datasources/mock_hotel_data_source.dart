import '../../domain/entities/hotel.dart';
import '../../domain/entities/province.dart';

/// Local, non-sensitive catalog used until a remote data source is connected.
abstract final class MockHotelDataSource {
  static const provinces = <Province>[
    Province(
        id: 'baghdad',
        nameAr: 'بغداد',
        nameEn: 'Baghdad',
        hotelsCount: 4,
        isFeatured: true),
    Province(
        id: 'basra',
        nameAr: 'البصرة',
        nameEn: 'Basra',
        hotelsCount: 3,
        isFeatured: true),
    Province(
        id: 'nineveh',
        nameAr: 'نينوى',
        nameEn: 'Nineveh',
        hotelsCount: 2,
        isFeatured: true),
    Province(
        id: 'erbil',
        nameAr: 'أربيل',
        nameEn: 'Erbil',
        hotelsCount: 4,
        isFeatured: true),
    Province(
        id: 'sulaymaniyah',
        nameAr: 'السليمانية',
        nameEn: 'Sulaymaniyah',
        hotelsCount: 3,
        isFeatured: true),
    Province(
        id: 'duhok',
        nameAr: 'دهوك',
        nameEn: 'Duhok',
        hotelsCount: 2,
        isFeatured: true),
    Province(id: 'kirkuk', nameAr: 'كركوك', nameEn: 'Kirkuk', hotelsCount: 1),
    Province(id: 'anbar', nameAr: 'الأنبار', nameEn: 'Anbar', hotelsCount: 1),
    Province(
        id: 'salah-al-din',
        nameAr: 'صلاح الدين',
        nameEn: 'Salah al-Din',
        hotelsCount: 1),
    Province(id: 'diyala', nameAr: 'ديالى', nameEn: 'Diyala', hotelsCount: 1),
    Province(id: 'wasit', nameAr: 'واسط', nameEn: 'Wasit', hotelsCount: 1),
    Province(id: 'maysan', nameAr: 'ميسان', nameEn: 'Maysan', hotelsCount: 1),
    Province(
        id: 'dhi-qar',
        nameAr: 'ذي قار',
        nameEn: 'Dhi Qar',
        hotelsCount: 2,
        isFeatured: true),
    Province(
        id: 'muthanna', nameAr: 'المثنى', nameEn: 'Muthanna', hotelsCount: 1),
    Province(
        id: 'qadisiyah',
        nameAr: 'القادسية',
        nameEn: 'Qadisiyah',
        hotelsCount: 1),
    Province(id: 'babil', nameAr: 'بابل', nameEn: 'Babil', hotelsCount: 2),
    Province(
        id: 'karbala',
        nameAr: 'كربلاء',
        nameEn: 'Karbala',
        hotelsCount: 2,
        isFeatured: true),
    Province(
        id: 'najaf',
        nameAr: 'النجف',
        nameEn: 'Najaf',
        hotelsCount: 3,
        isFeatured: true),
  ];

  static List<Hotel> hotels() => List<Hotel>.generate(25, (index) {
        final province = provinces[index % provinces.length];
        return Hotel(
          id: 'hotel-${index + 1}',
          nameAr: 'فندق ${[
            'دجلة',
            'الرافدين',
            'الواحة',
            'القلعة',
            'النخيل'
          ][index % 5]}',
          province: province,
          cityAr: province.nameAr,
          addressAr: 'وسط المدينة',
          rating: 4.1 + (index % 8) / 10,
          stars: 3 + index % 3,
          reviewsCount: 80 + index * 37,
          minimumPricePerNight: 80000 + index * 7500,
          category: HotelCategory.hotel,
          isFeatured: index % 3 == 0,
          isRecommended: index % 2 == 0,
          isPopular: index % 4 == 0,
          descriptionAr:
              'إقامة مريحة صممت لعرض تجربة حجوزاتي الفاخرة بالقرب من أهم معالم المدينة.',
          imageUrls: const [
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
            'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
          ],
          amenities: const [
            HotelAmenity.wifi,
            HotelAmenity.parking,
            HotelAmenity.restaurant,
            HotelAmenity.gym,
            HotelAmenity.reception24h,
            HotelAmenity.airConditioning
          ],
          roomTypes: const [
            RoomType(
                id: 'standard',
                nameAr: 'غرفة قياسية',
                descriptionAr: 'غرفة مريحة بسرير مزدوج',
                capacityAdults: 2,
                capacityChildren: 1,
                pricePerNight: 95000,
                availableRooms: 4,
                amenities: [
                  RoomAmenity.wifi,
                  RoomAmenity.airConditioning,
                  RoomAmenity.tv
                ],
                refundable: true,
                breakfastIncluded: true),
            RoomType(
                id: 'suite',
                nameAr: 'جناح عائلي',
                descriptionAr: 'جناح واسع مناسب للعائلات',
                capacityAdults: 4,
                capacityChildren: 2,
                pricePerNight: 150000,
                availableRooms: 2,
                amenities: [
                  RoomAmenity.wifi,
                  RoomAmenity.balcony,
                  RoomAmenity.safe
                ],
                refundable: false,
                breakfastIncluded: true),
          ],
          policies: const HotelPolicies(
              checkInFrom: '14:00',
              checkOutUntil: '12:00',
              childrenAllowed: true,
              petsAllowed: false,
              smokingAllowed: false,
              cancellationSummary: 'إلغاء مجاني حتى 24 ساعة قبل الوصول.'),
          latitude: 33.30 + (index % 5) * .015,
          longitude: 44.38 + (index % 5) * .018,
          discountPercentage: index % 5 == 0 ? 15 : null,
        );
      });
}
