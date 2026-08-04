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
          latitude: _coordinates(province.id, index).$1,
          longitude: _coordinates(province.id, index).$2,
          discountPercentage: index % 5 == 0 ? 15 : null,
        );
      });
}

(double, double) _coordinates(String province, int index) {
  final center = switch (province) {
    'baghdad' => (33.3152, 44.3661),
    'basra' => (30.5085, 47.7804),
    'nineveh' => (36.3456, 43.1575),
    'erbil' => (36.1911, 44.0092),
    'sulaymaniyah' => (35.5613, 45.4309),
    'duhok' => (36.8671, 42.9885),
    'kirkuk' => (35.4681, 44.3922),
    'dhi-qar' => (31.0439, 46.2573),
    'najaf' => (32.0000, 44.3300),
    'karbala' => (32.6160, 44.0249),
    'anbar' => (33.4258, 43.2992),
    'salah-al-din' => (34.6071, 43.6782),
    'diyala' => (33.7476, 44.6573),
    'wasit' => (32.5128, 45.8182),
    'maysan' => (31.8356, 47.1448),
    'muthanna' => (31.3190, 45.2806),
    'qadisiyah' => (31.9929, 44.9255),
    'babil' => (32.4721, 44.4217),
    _ => (0.0, 0.0),
  };
  final offset = (index % 4) * .008;
  return (center.$1 + offset, center.$2 - offset);
}
