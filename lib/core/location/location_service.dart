import '../result/app_result.dart';
enum LocationPermissionStatus { notRequested, denied, permanentlyDenied, granted, serviceDisabled }
class UserLocation { const UserLocation(this.latitude,this.longitude,{this.accuracyMeters}); final double latitude,longitude; final double? accuracyMeters; }
abstract interface class LocationService { Future<AppResult<LocationPermissionStatus>> checkPermission(); Future<AppResult<LocationPermissionStatus>> requestPermission(); Future<AppResult<UserLocation>> getCurrentLocation(); }
