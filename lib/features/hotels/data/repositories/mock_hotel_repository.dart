import 'dart:async';
import '../../domain/entities/hotel.dart';
import '../../domain/entities/province.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../datasources/mock_hotel_data_source.dart';

class MockHotelRepository implements HotelRepository {
  MockHotelRepository() : _hotels = MockHotelDataSource.hotels();
  List<Hotel> _hotels;
  final _controller = StreamController<List<Hotel>>.broadcast();
  @override Stream<List<Province>> watchProvinces() => Stream.value(MockHotelDataSource.provinces);
  @override Stream<List<Hotel>> watchHotels() async* { yield _hotels; yield* _controller.stream; }
  @override Future<Hotel?> getHotelById(String hotelId) async { for (final hotel in _hotels) { if (hotel.id == hotelId) return hotel; } return null; }
  @override Future<List<Hotel>> getSimilarHotels(String hotelId) async { final hotel = await getHotelById(hotelId); if (hotel == null) return const []; return _hotels.where((item) => item.id != hotelId && item.province.id == hotel.province.id).take(5).toList(growable:false); }
  @override Future<void> setFavorite(String hotelId, bool isFavorite) async { _hotels = _hotels.map((hotel) => hotel.id == hotelId ? hotel.copyWith(isFavorite:isFavorite) : hotel).toList(growable:false); _controller.add(_hotels); }
}
