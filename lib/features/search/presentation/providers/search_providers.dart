import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository();
});

final searchHotelsProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<dynamic>>>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository);
});

class SearchNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final SearchRepository _repository;

  SearchNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> searchHotels({
    required String destination,
    required String checkinDate,
    required String checkoutDate,
    int adultsNumber = 1,
    int roomNumber = 1,
  }) async {
    state = const AsyncValue.loading();
    try {
      final destId = await _repository.getDestinationId(destination);
      final hotels = await _repository.searchHotels(
        checkinDate: checkinDate,
        checkoutDate: checkoutDate,
        destId: destId,
        adultsNumber: adultsNumber,
        roomNumber: roomNumber,
      );
      print('Fetched ${hotels.length} hotels'); // Debug
      state = AsyncValue.data(hotels);
    } catch (e, stack) {
      print('Search error: $e'); // Debug
      state = AsyncValue.error(e, stack);
    }
  }
}