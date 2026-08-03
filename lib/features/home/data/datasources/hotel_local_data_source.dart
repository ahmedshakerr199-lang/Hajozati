import '../../domain/entities/hotel.dart';

abstract final class HotelLocalDataSource {
  static const featured = [
    Hotel(
      name: 'منتجع اللؤلؤة',
      location: 'دبي، الإمارات',
      price: 680,
      rating: 4.9,
      color: 0xFF0E7490,
    ),
    Hotel(
      name: 'قصر البحر',
      location: 'صلالة، عُمان',
      price: 450,
      rating: 4.8,
      color: 0xFF2563A6,
    ),
    Hotel(
      name: 'واحة السحاب',
      location: 'العلا، السعودية',
      price: 510,
      rating: 4.7,
      color: 0xFFB77935,
    ),
  ];
}
