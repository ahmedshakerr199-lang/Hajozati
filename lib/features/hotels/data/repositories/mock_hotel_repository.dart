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
  @override Future<void> setFavorite(String hotelId, bool isFavorite) async { _hotels = _hotels.map((hotel) => hotel.id == hotelId ? hotel.copyWith(isFavorite:isFavorite) : hotel).toList(growable:false); _controller.add(_hotels); }
}
