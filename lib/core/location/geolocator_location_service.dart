import 'package:geolocator/geolocator.dart';

import '../result/app_result.dart';
import 'location_service.dart';

/// Production adapter for the location plugin. It never stores a position.
class GeolocatorLocationService implements LocationService {
  @override
  Future<AppResult<bool>> isLocationServiceEnabled() async {
    try {
      return AppSuccess(await Geolocator.isLocationServiceEnabled());
    } catch (_) {
      return const AppFailure(UnknownAppError('تعذر التحقق من خدمة الموقع.'));
    }
  }

  @override
  Future<AppResult<LocationPermissionStatus>> checkPermission() async {
    try {
      return AppSuccess(_mapPermission(await Geolocator.checkPermission()));
    } catch (_) {
      return const AppFailure(UnknownAppError('تعذر التحقق من إذن الموقع.'));
    }
  }

  @override
  Future<AppResult<LocationPermissionStatus>> requestPermission() async {
    try {
      return AppSuccess(_mapPermission(await Geolocator.requestPermission()));
    } catch (_) {
      return const AppFailure(PermissionAppError('تعذر طلب إذن الموقع.'));
    }
  }

  @override
  Future<AppResult<UserLocation>> getCurrentLocation() async {
    final enabled = await isLocationServiceEnabled();
    if (enabled case AppSuccess(data: false)) {
      return const AppFailure(
        LocationServiceDisabledAppError(
            'يرجى تشغيل خدمة الموقع للعثور على الفنادق القريبة.'),
      );
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      return AppSuccess(UserLocation(
        position.latitude,
        position.longitude,
        accuracyMeters: position.accuracy,
      ));
    } on LocationServiceDisabledException {
      return const AppFailure(
          LocationServiceDisabledAppError('خدمة الموقع متوقفة.'));
    } on PermissionDeniedException {
      return const AppFailure(PermissionAppError('لم يتم منح إذن الموقع.'));
    } catch (_) {
      return const AppFailure(UnknownAppError('تعذر تحديد موقعك الآن.'));
    }
  }

  @override
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  LocationPermissionStatus _mapPermission(LocationPermission permission) =>
      switch (permission) {
        LocationPermission.always ||
        LocationPermission.whileInUse =>
          LocationPermissionStatus.granted,
        LocationPermission.deniedForever =>
          LocationPermissionStatus.permanentlyDenied,
        LocationPermission.denied => LocationPermissionStatus.denied,
        LocationPermission.unableToDetermine =>
          LocationPermissionStatus.notRequested,
      };
}
