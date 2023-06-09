import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:key_value_storage/key_value_storage.dart';

/// {@template coffee_repository}
/// Repository to access coffee data from both CoffeeApi and KeyValueStorage
/// {@endtemplate}
class CoffeeRepository {
  /// {@macro coffee_repository}
  const CoffeeRepository({
    required this.api,
    required this.storage,
  });

  /// Service to fetch [Coffee] images
  final CoffeeApi api;

  /// Storage to cache favorite [Coffee]
  final CoffeeLocalStorage storage;

  /// Returns the url for a [Coffee]
  Future<String> getRandomCoffeeUrl() async {
    final urlHolder = await api.getCoffeeUrlHolder();

    return urlHolder.url;
  }

  /// Verify if the [Coffee] is cached on local storage
  ///
  /// It uses the [FavoriteCoffee]'s id as key
  Future<bool> isCoffeeFavorite(String id) {
    return storage.isCoffeeFavorite(id);
  }

  /// Verify if the [Coffee] is cached on local storage
  ///
  /// It uses the [FavoriteCoffee]'s url as key
  Future<bool> isCoffeeFavoriteFromUrl(String url) {
    return storage.isCoffeeFavoriteFromUrl(url);
  }

  /// Obtain all favorite [Coffee] from local storage
  Future<List<Coffee>> getFavoriteCoffees() async {
    final favoriteCoffees = await storage.getFavoriteCoffees();

    return favoriteCoffees.map((coffee) {
      return Coffee(
        id: coffee.id,
        isFavorite: true,
        url: coffee.url,
      );
    }).toList();
  }

  /// Favorites, and caches, the [Coffee] data on local storage
  Future<void> favoriteCoffee(Coffee coffee) {
    return storage.favoriteCoffee(
      FavoriteCoffee(id: coffee.id, url: coffee.url),
    );
  }

  /// Unfavorites, and deletes from cache, the [Coffee] data on
  /// local storage
  ///
  /// It uses the [FavoriteCoffee]'s id as key
  Future<void> unfavoriteCoffee(String id) {
    return storage.unfavoriteCoffee(id);
  }
}
