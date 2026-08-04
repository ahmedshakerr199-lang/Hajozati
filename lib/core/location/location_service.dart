import '../result/app_result.dart';

enum LocationPermissionStatus {
  notRequested,
  denied,
  permanentlyDenied,
  granted
}

/// A short-lived device position. It is deliberately not persisted or logged.
class UserLocation {
  const UserLocation(this.latitude, this.longitude, {this.accuracyMeters});
  final double latitude;
  final double longitude;
  final double? accuracyMeters;
}

/// Device location boundary; plugins stay outside domain and presentation layers.
abstract interface class LocationService {
  Future<AppResult<bool>> isLocationServiceEnabled();
  Future<AppResult<LocationPermissionStatus>> checkPermission();
  Future<AppResult<LocationPermissionStatus>> requestPermission();
  Future<AppResult<UserLocation>> getCurrentLocation();
  Future<void> openAppSettings();
  Future<void> openLocationSettings();
}
