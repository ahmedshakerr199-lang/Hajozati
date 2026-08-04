import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/tourist_destination.dart';
import '../../domain/usecases/explore_use_cases.dart';
import '../../../../core/result/app_result.dart';

enum ExploreState { loading, success, empty, error }

class ExploreViewModel extends ChangeNotifier {
  ExploreViewModel(this._all, this._featured, this._popular, this._search,
      this._province, this._category);
  final GetDestinationsUseCase _all;
  final GetFeaturedDestinationsUseCase _featured;
  final GetPopularDestinationsUseCase _popular;
  final SearchDestinationsUseCase _search;
  final FilterDestinationsByProvinceUseCase _province;
  final FilterDestinationsByCategoryUseCase _category;
  ExploreState state = ExploreState.loading;
  List<TouristDestination> destinations = const [];
  List<TouristDestination> featured = const [];
  List<TouristDestination> popular = const [];
  String query = '';
  String? selectedProvince;
  DestinationCategory? selectedCategory;
  String? error;
  List<TouristDestination> _allItems = const [];
  List<String> get provinces =>
      _allItems.map((item) => item.provinceId).toSet().toList()..sort();
  StreamSubscription<List<TouristDestination>>? _subscription;
  Future<void> load() async {
    state = ExploreState.loading;
    notifyListeners();
    _subscription?.cancel();
    _subscription = _all().listen((items) {
      _allItems = items;
      destinations = items;
      state = items.isEmpty ? ExploreState.empty : ExploreState.success;
      notifyListeners();
    }, onError: (_) {
      state = ExploreState.error;
      error = 'تعذر تحميل الوجهات.';
      notifyListeners();
    });
    featured = await _featured().first;
    popular = await _popular().first;
    notifyListeners();
  }

  Future<void> search(String value) async {
    query = value;
    selectedProvince = null;
    selectedCategory = null;
    final result = await _search(value);
    _apply(result);
  }

  Future<void> filterProvince(String? id) async {
    selectedProvince = id;
    selectedCategory = null;
    query = '';
    if (id == null) {
      destinations = _allItems;
      state = destinations.isEmpty ? ExploreState.empty : ExploreState.success;
      notifyListeners();
      return;
    }
    _apply(await _province(id));
  }

  Future<void> filterCategory(DestinationCategory? category) async {
    selectedCategory = category;
    selectedProvince = null;
    query = '';
    if (category == null) {
      destinations = _allItems;
      state = destinations.isEmpty ? ExploreState.empty : ExploreState.success;
      notifyListeners();
      return;
    }
    _apply(await _category(category));
  }

  void _apply(AppResult<List<TouristDestination>> result) {
    if (result case AppSuccess(data: final data)) {
      destinations = data;
      state = data.isEmpty ? ExploreState.empty : ExploreState.success;
    } else if (result case AppFailure(error: final value)) {
      state = ExploreState.error;
      error = value.message;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
