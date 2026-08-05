import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../../../hotels/domain/entities/province.dart';
import '../../../hotels/domain/repositories/hotel_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository);
  final HotelRepository _repository;
  HotelRepository get repository => _repository;
  List<Hotel> hotels = const [];
  List<Province> provinces = const [];
  List<Hotel> featured = const [];
  List<Hotel> popular = const [];
  List<Hotel> recommended = const [];
  bool isLoading = true;
  String? error;
  StreamSubscription<List<Hotel>>? _hotelsSubscription;
  StreamSubscription<List<Province>>? _provincesSubscription;
  bool _hasLoaded = false;

  void load() {
    if (_hasLoaded) {
      return;
    }
    _hasLoaded = true;
    _hotelsSubscription = _repository.watchHotels().listen((value) {
      hotels = value;
      featured = _section(value, (hotel) => hotel.isFeatured);
      popular = _section(value, (hotel) => hotel.isPopular);
      recommended = _section(value, (hotel) => hotel.isRecommended);
      isLoading = false;
      notifyListeners();
    }, onError: (Object _) {
      _hasLoaded = false;
      error = 'تعذر تحميل الإقامات';
      isLoading = false;
      notifyListeners();
    });
    _provincesSubscription = _repository.watchProvinces().listen((value) {
      provinces = value;
      notifyListeners();
    });
  }

  /// Limits homepage sections so a growing catalog never creates thousands of cards.
  List<Hotel> _section(
    List<Hotel> source,
    bool Function(Hotel hotel) predicate,
  ) =>
      List.unmodifiable(source.where(predicate).take(10));

  void retry() {
    _hotelsSubscription?.cancel();
    _provincesSubscription?.cancel();
    _hasLoaded = false;
    isLoading = true;
    error = null;
    load();
  }

  @override
  void dispose() {
    _hotelsSubscription?.cancel();
    _provincesSubscription?.cancel();
    super.dispose();
  }
}
