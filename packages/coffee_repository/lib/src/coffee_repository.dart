import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';

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

  /// Returns a [Coffee] object, which already checks if it is favorite or not
  Future<Coffee> getRandomCoffee() async {
    final bytes = await api.getCoffeeBytes();
    final isFavorite = await storage.isCoffeeFavorite(bytes);

    return Coffee(bytes: bytes, isFavorite: isFavorite);
  }

  /// Verify if the [Coffee] is cached on local storage
  Future<bool> isCoffeeFavorite(Coffee coffee) {
    return storage.isCoffeeFavorite(coffee.bytes);
  }

  /// Obtain all favorite [Coffee] from local storage
  Future<List<Coffee>> getFavoriteCoffees() async {
    final favoriteCoffees = await storage.getFavoriteCoffees();

    return favoriteCoffees.map((coffee) {
      return Coffee(
        bytes: coffee.bytes,
        isFavorite: true,
        url: coffee.url,
      );
    }).toList();
  }

  /// Favorites, and caches, the [Coffee] data on local storage
  Future<void> favoriteCoffee(Coffee coffee) {
    return storage.favoriteCoffee(coffee.bytes, url: coffee.url);
  }

  /// Unfavorites, and deletes from cache, the [Coffee] data on
  /// local storage
  Future<void> unfavoriteCoffee(Coffee coffee) {
    return storage.unfavoriteCoffee(coffee.bytes);
  }
}
