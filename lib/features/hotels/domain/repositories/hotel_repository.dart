import '../entities/hotel.dart';
import '../entities/province.dart';

abstract interface class HotelRepository {
  Stream<List<Province>> watchProvinces();
  Stream<List<Hotel>> watchHotels();
  Future<void> setFavorite(String hotelId, bool isFavorite);
}
