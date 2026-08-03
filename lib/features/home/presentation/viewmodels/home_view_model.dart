import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../../../hotels/domain/entities/province.dart';
import '../../../hotels/domain/repositories/hotel_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository);
  final HotelRepository _repository;
  HotelRepository get repository => _repository;
  List<Hotel> hotels = const []; List<Province> provinces = const []; bool isLoading = true; String? error;
  StreamSubscription<List<Hotel>>? _hotelsSubscription; StreamSubscription<List<Province>>? _provincesSubscription;
  void load() { _hotelsSubscription = _repository.watchHotels().listen((value) { hotels=value; isLoading=false; notifyListeners(); },onError:(Object _) { error='تعذر تحميل الإقامات';isLoading=false;notifyListeners(); }); _provincesSubscription = _repository.watchProvinces().listen((value) { provinces=value; notifyListeners(); }); }
  List<Hotel> get featured => hotels.where((item)=>item.isFeatured).toList(growable:false); List<Hotel> get popular => hotels.where((item)=>item.isPopular).toList(growable:false); List<Hotel> get recommended => hotels.where((item)=>item.isRecommended).toList(growable:false);
  @override void dispose(){_hotelsSubscription?.cancel();_provincesSubscription?.cancel();super.dispose();}
}
