import '../../domain/entities/tourist_destination.dart';

/// Curated Iraqi destinations for offline exploration previews.
abstract final class MockDestinations {
  static const _imageUrls = <String>[
    'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e',
    'https://images.unsplash.com/photo-1564399579883-451a5d44ec08',
    'https://images.unsplash.com/photo-1548013146-72479768bada',
    'https://images.unsplash.com/photo-1529260830199-42c24126f198',
    'https://images.unsplash.com/photo-1518005020951-eccb494ad742',
  ];

  static final List<TouristDestination> data =
      List<TouristDestination>.unmodifiable([
    _item('ur-ziggurat', 'زقورة أور', 'Ziggurat of Ur', 'dhi-qar', 'الناصرية',
        DestinationCategory.archaeologicalSite, 30.96, 46.10),
    _item('chibayish', 'أهوار الجبايش', 'Chibayish Marshes', 'dhi-qar',
        'الجبايش', DestinationCategory.naturalAttraction, 31.00, 47.00),
    _item('iraqi-museum', 'المتحف العراقي', 'Iraqi Museum', 'baghdad', 'بغداد',
        DestinationCategory.museum, 33.34, 44.38),
    _item('mutanabbi', 'شارع المتنبي', 'Al-Mutanabbi Street', 'baghdad',
        'بغداد', DestinationCategory.heritageMarket, 33.34, 44.40),
    _item('martyr-monument', 'نصب الشهيد', 'Martyr Monument', 'baghdad',
        'بغداد', DestinationCategory.monument, 33.31, 44.44),
    _item('erbil-citadel', 'قلعة أربيل', 'Erbil Citadel', 'erbil', 'أربيل',
        DestinationCategory.archaeologicalSite, 36.19, 44.01),
    _item('bekhal', 'شلالات بيخال', 'Bekhal Waterfalls', 'erbil', 'رواندوز',
        DestinationCategory.naturalAttraction, 36.62, 44.54),
    _item('shaqlawa', 'شقلاوة', 'Shaqlawa', 'erbil', 'شقلاوة',
        DestinationCategory.naturalAttraction, 36.40, 44.33),
    _item('dukan', 'بحيرة دوكان', 'Dukan Lake', 'sulaymaniyah', 'دوكان',
        DestinationCategory.naturalAttraction, 35.95, 44.95),
    _item('azmar', 'جبل أزمر', 'Azmar Mountain', 'sulaymaniyah', 'السليمانية',
        DestinationCategory.naturalAttraction, 35.58, 45.40),
    _item('shatt-al-arab', 'كورنيش شط العرب', 'Shatt al-Arab Corniche', 'basra',
        'البصرة', DestinationCategory.waterfront, 30.51, 47.82),
    _item('basra-museum', 'متحف حضارة البصرة', 'Basra Civilization Museum',
        'basra', 'البصرة', DestinationCategory.museum, 30.50, 47.81),
    _item('babylon', 'مدينة بابل الأثرية', 'Babylon Archaeological City',
        'babil', 'الحلة', DestinationCategory.archaeologicalSite, 32.54, 44.42),
    _item('nimrud', 'النمرود', 'Nimrud', 'nineveh', 'الموصل',
        DestinationCategory.archaeologicalSite, 36.09, 43.33),
    _item('nuri-mosque', 'جامع النوري', 'Al-Nuri Mosque', 'nineveh', 'الموصل',
        DestinationCategory.religiousSite, 36.34, 43.13),
    _item('imam-ali', 'مرقد الإمام علي', 'Imam Ali Shrine', 'najaf', 'النجف',
        DestinationCategory.religiousSite, 32.00, 44.33),
    _item('imam-hussein', 'مرقد الإمام الحسين', 'Imam Hussein Shrine',
        'karbala', 'كربلاء', DestinationCategory.religiousSite, 32.62, 44.03),
    _item('nukhayla', 'خان النخيلة', 'Khan al-Nukhayla', 'karbala', 'كربلاء',
        DestinationCategory.heritageMarket, 32.58, 44.03),
    _item('habbaniyah', 'بحيرة الحبانية', 'Habbaniyah Lake', 'anbar', 'الرمادي',
        DestinationCategory.familyAttraction, 33.33, 43.57),
    _item('malwiya', 'ملوية سامراء', 'Malwiya Minaret', 'salah-al-din',
        'سامراء', DestinationCategory.monument, 34.20, 43.88),
  ]);

  static TouristDestination _item(
      String id,
      String ar,
      String en,
      String province,
      String city,
      DestinationCategory category,
      double latitude,
      double longitude) {
    final image = _imageUrls[dataSeed(id) % _imageUrls.length];
    return TouristDestination(
        id: id,
        nameAr: ar,
        nameEn: en,
        descriptionAr: 'وجهة عراقية مميزة تستحق الزيارة والتعرّف إلى قصتها.',
        descriptionEn: 'A distinctive Iraqi destination worth discovering.',
        provinceId: province,
        cityAr: city,
        cityEn: city,
        addressAr: city,
        addressEn: city,
        latitude: latitude,
        longitude: longitude,
        coverImageUrl: image,
        imageUrls: [image, _imageUrls[(dataSeed(id) + 1) % _imageUrls.length]],
        category: category,
        isFeatured: dataSeed(id).isEven,
        isPopular: dataSeed(id) % 3 == 0,
        suggestedVisitHours: 2,
        openingHoursAr: 'يوميًا 9:00 ص - 6:00 م',
        openingHoursEn: 'Daily 9 AM - 6 PM',
        entryIsFree: true,
        tagsAr: [city],
        tagsEn: [en]);
  }

  static int dataSeed(String value) =>
      value.codeUnits.fold(0, (total, item) => total + item);
}
