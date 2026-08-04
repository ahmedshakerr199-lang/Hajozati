import 'search_models.dart';

abstract interface class SearchRepository {
  Future<SearchResult> search(SearchQuery query);
  Future<List<String>> suggestions(String query);
  Future<List<String>> recentSearches();
  Future<void> saveRecent(String query);
  Future<void> clearRecent();
}
