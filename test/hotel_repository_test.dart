import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/hotels/data/datasources/mock_hotel_data_source.dart';
import 'package:hajozati/features/hotels/data/repositories/mock_hotel_repository.dart';
import 'package:hajozati/features/hotels/domain/entities/hotel.dart';

void main() {
  test('approved provinces are exactly eighteen with no Halabja', () {
    expect(MockHotelDataSource.provinces, hasLength(18));
    expect(MockHotelDataSource.provinces.any((item) => item.id == 'halabja'), isFalse);
  });
  test('hotel amenities contain no Spa', () {
    expect(HotelAmenity.values.any((item) => item.name == 'spa'), isFalse);
    expect(MockHotelDataSource.hotels().every((hotel) => !hotel.amenities.any((item) => item.name == 'spa')), isTrue);
  });
  test('loads details and similar hotels from the same province', () async {
    final repository = MockHotelRepository();
    final hotel = await repository.getHotelById('hotel-1');
    final similar = await repository.getSimilarHotels('hotel-1');
    expect(hotel, isNotNull);
    expect(similar.every((item) => item.province.id == hotel!.province.id), isTrue);
  });
  test('unknown hotel returns empty and favorite can change', () async {
    final repository = MockHotelRepository();
    expect(await repository.getHotelById('missing'), isNull);
    await repository.setFavorite('hotel-1', true);
    expect((await repository.getHotelById('hotel-1'))!.isFavorite, isTrue);
  });
}
