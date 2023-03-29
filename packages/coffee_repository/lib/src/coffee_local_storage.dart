import 'package:key_value_storage/key_value_storage.dart';

/// {@template coffee_local_storage}
/// Storage to cache favorite coffee
/// {@endtemplate}
class CoffeeLocalStorage {
  /// {@macro coffee_local_storage}
  const CoffeeLocalStorage({
    required this.storage,
  });

  /// A wrapper around the local storage to access cached data
  final KeyValueStorage storage;

  /// Favorites, and caches, the coffee image data on local storage
  Future<void> favoriteCoffee(FavoriteCoffee coffee) async {
    final box = await storage.favoriteCoffeeBox;

    await box.put(coffee.url, coffee);
  }

  /// Unfavorites, and deletes from cache, the coffee image data on
  /// local storage
  Future<void> unfavoriteCoffee(FavoriteCoffee coffee) async {
    final box = await storage.favoriteCoffeeBox;

    await box.delete(coffee.url);
  }

  /// Obtain all favorite coffee from local storage
  Future<List<FavoriteCoffee>> getFavoriteCoffees() async {
    final box = await storage.favoriteCoffeeBox;

    return box.values.toList();
  }

  /// Verify if the coffee bytes is cached on local storage
  Future<bool> isCoffeeFavorite(FavoriteCoffee coffee) async {
    final box = await storage.favoriteCoffeeBox;

    final favoriteCoffee = box.get(coffee.url);

    return favoriteCoffee != null;
  }
}
