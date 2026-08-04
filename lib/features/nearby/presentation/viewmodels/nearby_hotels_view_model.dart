import 'package:flutter/foundation.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/result/app_result.dart';
import '../../domain/nearby_hotels.dart';

enum NearbyViewState {
  idle,
  loading,
  success,
  permissionDenied,
  permanentlyDenied,
  serviceDisabled,
  locationUnavailable,
  error
}

class NearbyHotelsViewModel extends ChangeNotifier {
  NearbyHotelsViewModel(this._location, this._nearby);
  final LocationService _location;
  final GetNearbyHotelsUseCase _nearby;
  NearbyViewState state = NearbyViewState.idle;
  List<NearbyHotel> allHotels = const [];
  NearbyRange range = NearbyRange.all;
  String? message;
  List<NearbyHotel> get hotels => switch (range) {
        NearbyRange.all => allHotels,
        _ => allHotels
            .where((item) => item.distanceKm <= _rangeKm(range))
            .toList(growable: false)
      };

  Future<void> load() async {
    state = NearbyViewState.loading;
    message = null;
    notifyListeners();
    final enabled = await _location.isLocationServiceEnabled();
    if (enabled case AppFailure(error: final failure)) {
      _setError(failure);
      return;
    }
    if (enabled case AppSuccess(data: false)) {
      state = NearbyViewState.serviceDisabled;
      notifyListeners();
      return;
    }
    final permission = await _location.checkPermission();
    if (permission case AppFailure(error: final failure)) {
      _setError(failure);
      return;
    }
    if (permission
        case AppSuccess(data: LocationPermissionStatus.permanentlyDenied)) {
      state = NearbyViewState.permanentlyDenied;
      notifyListeners();
      return;
    }
    if (permission case AppSuccess(data: final value)
        when value != LocationPermissionStatus.granted) {
      state = NearbyViewState.permissionDenied;
      notifyListeners();
      return;
    }
    final position = await _location.getCurrentLocation();
    if (position case AppFailure(error: final error)) {
      _setError(error);
      return;
    }
    final found = await _nearby((position as AppSuccess).data);
    if (found case AppFailure(error: final error)) {
      _setError(error);
      return;
    }
    allHotels = (found as AppSuccess<List<NearbyHotel>>).data;
    state = NearbyViewState.success;
    notifyListeners();
  }

  Future<void> requestPermission() async {
    final result = await _location.requestPermission();
    if (result case AppFailure(error: final error)) {
      _setError(error);
      return;
    }
    await load();
  }

  void setRange(NearbyRange value) {
    range = value;
    notifyListeners();
  }

  Future<void> openSettings() => _location.openAppSettings();
  Future<void> openLocationSettings() => _location.openLocationSettings();
  void _setError(AppError error) {
    state = error is LocationServiceDisabledAppError
        ? NearbyViewState.serviceDisabled
        : error is PermissionAppError
            ? NearbyViewState.permissionDenied
            : NearbyViewState.error;
    message = error.message;
    notifyListeners();
  }

  double _rangeKm(NearbyRange value) => switch (value) {
        NearbyRange.km5 => 5,
        NearbyRange.km10 => 10,
        NearbyRange.km25 => 25,
        NearbyRange.km50 => 50,
        NearbyRange.all => double.infinity
      };
}
