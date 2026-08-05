import 'dart:async';

import 'package:flutter/foundation.dart';
import '../domain/search_models.dart';
import '../domain/search_use_cases.dart';
import '../domain/search_repository.dart';
import '../domain/hotel_search_criteria.dart';
import '../../hotels/domain/entities/hotel.dart';

enum SearchState { idle, loading, success, empty, error }

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(
      this._search, this._suggestions, this._save, this._clear, this._repo);
  final SearchHotelsUseCase _search;
  final GetSearchSuggestionsUseCase _suggestions;
  final SaveRecentSearchUseCase _save;
  final ClearRecentSearchesUseCase _clear;
  final SearchRepository _repo;
  SearchState state = SearchState.idle;
  String query = '';
  SearchFilter filter = const SearchFilter();
  SortOption sort = SortOption.highestRated;
  List<Hotel> results = const [];
  List<String> recent = const [], suggestions = const [];
  String? error;
  Timer? _searchDebounce;
  int _requestVersion = 0;

  /// Debounces keyboard input while keeping [search] directly testable.
  void scheduleSearch(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      search(value);
    });
  }

  Future<void> search(String value) async {
    final requestVersion = ++_requestVersion;
    query = value;
    state = SearchState.loading;
    notifyListeners();
    try {
      final nextSuggestions = await _suggestions(value);
      final result =
          await _search(SearchQuery(text: value, filter: filter, sort: sort));
      if (requestVersion != _requestVersion) {
        return;
      }
      suggestions = nextSuggestions;
      results = result.hotels;
      state = results.isEmpty ? SearchState.empty : SearchState.success;
      if (value.trim().isNotEmpty) {
        await _save(value);
        recent = await _repo.recentSearches();
      }
    } catch (_) {
      if (requestVersion != _requestVersion) {
        return;
      }
      state = SearchState.error;
      error = 'حدث خطأ أثناء البحث.';
    }
    notifyListeners();
  }

  Future<void> clear() async {
    _searchDebounce?.cancel();
    _requestVersion++;
    query = '';
    results = const [];
    await _clear();
    recent = const [];
    state = SearchState.idle;
    notifyListeners();
  }

  Future<void> retry() => search(query);

  /// Searches using an immutable panel criteria without filtering in widgets.
  Future<void> searchCriteria(HotelSearchCriteria criteria) async {
    filter = SearchFilter(provinceId: criteria.provinceId);
    await search('');
  }

  Future<void> changeFilters(SearchFilter value) async {
    filter = value;
    await search(query);
  }

  Future<void> changeSort(SortOption value) async {
    sort = value;
    await search(query);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
