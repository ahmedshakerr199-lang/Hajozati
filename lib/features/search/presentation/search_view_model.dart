import 'package:flutter/foundation.dart';
import '../domain/search_models.dart';
import '../domain/search_use_cases.dart';
import '../domain/search_repository.dart';
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
  Future<void> search(String value) async {
    query = value;
    state = SearchState.loading;
    notifyListeners();
    try {
      suggestions = await _suggestions(value);
      final result =
          await _search(SearchQuery(text: value, filter: filter, sort: sort));
      results = result.hotels;
      state = results.isEmpty ? SearchState.empty : SearchState.success;
      if (value.trim().isNotEmpty) {
        await _save(value);
        recent = await _repo.recentSearches();
      }
    } catch (_) {
      state = SearchState.error;
      error = 'حدث خطأ أثناء البحث.';
    }
    notifyListeners();
  }

  Future<void> clear() async {
    query = '';
    results = const [];
    await _clear();
    recent = const [];
    state = SearchState.idle;
    notifyListeners();
  }

  Future<void> retry() => search(query);
  Future<void> changeFilters(SearchFilter value) async {
    filter = value;
    await search(query);
  }

  Future<void> changeSort(SortOption value) async {
    sort = value;
    await search(query);
  }
}
