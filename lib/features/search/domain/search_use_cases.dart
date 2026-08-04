import 'search_models.dart';
import 'search_repository.dart';

class SearchHotelsUseCase {
  const SearchHotelsUseCase(this.repository);
  final SearchRepository repository;
  Future<SearchResult> call(SearchQuery query) => repository.search(query);
}

class FilterHotelsUseCase {
  const FilterHotelsUseCase(this.repository);
  final SearchRepository repository;
  Future<SearchResult> call(SearchQuery query) => repository.search(query);
}

class SortHotelsUseCase {
  const SortHotelsUseCase(this.repository);
  final SearchRepository repository;
  Future<SearchResult> call(SearchQuery query) => repository.search(query);
}

class GetSearchSuggestionsUseCase {
  const GetSearchSuggestionsUseCase(this.repository);
  final SearchRepository repository;
  Future<List<String>> call(String q) => repository.suggestions(q);
}

class ClearRecentSearchesUseCase {
  const ClearRecentSearchesUseCase(this.repository);
  final SearchRepository repository;
  Future<void> call() => repository.clearRecent();
}

class SaveRecentSearchUseCase {
  const SaveRecentSearchUseCase(this.repository);
  final SearchRepository repository;
  Future<void> call(String q) => repository.saveRecent(q);
}
