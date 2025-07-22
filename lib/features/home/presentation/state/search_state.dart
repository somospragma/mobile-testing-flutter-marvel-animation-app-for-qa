import '../../../../shared/domain/models/item_model.dart';

class SearchState {
  final List<ItemModel> searchResults;
  final String searchQuery;
  final bool isSearching;
  final bool isSearchActive;
  final String? errorMessage;

  const SearchState({
    this.searchResults = const [],
    this.searchQuery = '',
    this.isSearching = false,
    this.isSearchActive = false,
    this.errorMessage,
  });

  SearchState copyWith({
    List<ItemModel>? searchResults,
    String? searchQuery,
    bool? isSearching,
    bool? isSearchActive,
    String? errorMessage,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
