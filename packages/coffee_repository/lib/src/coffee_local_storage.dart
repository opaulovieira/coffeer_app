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

    await box.put(coffee.id, coffee);
  }

  /// Unfavorites, and deletes from cache, the coffee image data on
  /// local storage
  ///
  /// It uses the [FavoriteCoffee]'s id as key
  Future<void> unfavoriteCoffee(String id) async {
    final box = await storage.favoriteCoffeeBox;

    await box.delete(id);
  }

  /// Obtain all favorite coffee from local storage
  Future<List<FavoriteCoffee>> getFavoriteCoffees() async {
    final box = await storage.favoriteCoffeeBox;

    return box.values.toList();
  }

  /// Verify if the coffee bytes is cached on local storage
  ///
  /// It uses the [FavoriteCoffee]'s id as key
  Future<bool> isCoffeeFavorite(String id) async {
    final box = await storage.favoriteCoffeeBox;

    final favoriteCoffee = box.get(id);

    return favoriteCoffee != null;
  }
}
