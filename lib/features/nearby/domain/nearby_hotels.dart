import 'dart:math';

import '../../../core/location/location_service.dart';
import '../../../core/result/app_result.dart';
import '../../hotels/domain/entities/hotel.dart';
import '../../hotels/domain/repositories/hotel_repository.dart';

class NearbyHotel {
  const NearbyHotel(this.hotel, this.distanceKm);
  final Hotel hotel;
  final double distanceKm;
}

enum NearbyRange { all, km5, km10, km25, km50 }

class CalculateDistanceUseCase {
  double call(UserLocation origin, double latitude, double longitude) {
    const radius = 6371.0;
    final dLat = _rad(latitude - origin.latitude);
    final dLng = _rad(longitude - origin.longitude);
    final value = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(origin.latitude)) *
            cos(_rad(latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return 2 * radius * atan2(sqrt(value), sqrt(1 - value));
  }

  double _rad(double value) => value * pi / 180;
}

class GetNearbyHotelsUseCase {
  GetNearbyHotelsUseCase(this._repository, this._distance);
  final HotelRepository _repository;
  final CalculateDistanceUseCase _distance;
  Future<AppResult<List<NearbyHotel>>> call(UserLocation location) async {
    final hotels = await _repository.watchHotels().first;
    final nearby = hotels
        .where((hotel) => hotel.hasValidCoordinates)
        .map((hotel) => NearbyHotel(
            hotel, _distance(location, hotel.latitude, hotel.longitude)))
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return AppSuccess(nearby);
  }
}
