import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/core/location/location_service.dart';
import 'package:hajozati/features/nearby/domain/nearby_hotels.dart';

void main() {
  test('haversine returns zero for identical coordinates', () {
    expect(
        CalculateDistanceUseCase()(
            const UserLocation(33.3152, 44.3661), 33.3152, 44.3661),
        closeTo(0, .001));
  });
  test('haversine returns a positive distance for different coordinates', () {
    expect(
        CalculateDistanceUseCase()(
            const UserLocation(33.3152, 44.3661), 30.5085, 47.7804),
        greaterThan(100));
  });
}
