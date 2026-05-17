import 'event.dart';

class FavoriteEvents {

  static final List<Event> favorites = [];

  static bool isFavorite(Event event) {
    return favorites.any((e) => e.buyUrl == event.buyUrl);
  }

  static void toggleFavorite(Event event) {

    final existingIndex = favorites.indexWhere(
            (e) => e.buyUrl == event.buyUrl
    );

    if (existingIndex >= 0) {
      favorites.removeAt(existingIndex);
    } else {
      favorites.add(event);
    }
  }
}