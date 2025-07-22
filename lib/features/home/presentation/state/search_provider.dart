import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models/item_model.dart';
import 'search_state.dart';
import 'home_provider.dart';
import '../../domain/usecases/home_usecase.dart';
import '../../domain/entities/hero.dart';
import '../../../../core/network/error/failures.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;

  SearchNotifier(this.ref) : super(const SearchState());

  void toggleSearch() {
    state = state.copyWith(
      isSearchActive: !state.isSearchActive,
      searchQuery: '',
      searchResults: [],
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    if (query.isEmpty) {
      state = state.copyWith(searchResults: []);
    } else {
      _performSearch(query);
    }
  }

  void _performSearch(String query) async {
    state = state.copyWith(isSearching: true, errorMessage: null);
    
    try {
      // Step 1: Search locally first
      final currentHeroes = ref.read(homeProvider).heroes;
      final filteredHeroes = currentHeroes.where((hero) {
        return hero.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      // If we found local results, show them
      if (filteredHeroes.isNotEmpty) {
        state = state.copyWith(
          searchResults: filteredHeroes,
          isSearching: false,
        );
        return;
      }
      
      // Step 2: If no local results, search via API
      final homeUsecase = ref.read(homeUsecaseProvider);
      final apiResult = await homeUsecase.searchHeroesByName(name: query);
      
      apiResult.when(
        (Failure failure) {
          state = state.copyWith(
            searchResults: [],
            isSearching: false,
            errorMessage: 'No heroes found for "$query"',
          );
        },
        (List<Hero> apiHeroes) {
          // Convert Hero entities to ItemModel for UI
          final apiResults = apiHeroes.map((hero) => ItemModel(
            id: hero.id,
            title: hero.name,
            imageUrl: hero.picture,
            subtitle: hero.fullName ?? hero.description,
            buttonText: 'View Details',
          )).toList();
          
          state = state.copyWith(
            searchResults: apiResults,
            isSearching: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error searching heroes: $e',
        isSearching: false,
        searchResults: [],
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      searchResults: [],
      isSearchActive: false,
      errorMessage: null,
    );
  }
}
