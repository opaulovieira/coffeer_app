import 'dart:typed_data';

import 'package:key_value_storage/key_value_storage.dart';
import 'package:uuid/uuid.dart';

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

  static final _keysMap = <Uint8List, String>{};

  /// Favorites, and caches, the coffee image data on local storage
  Future<void> favoriteCoffee(FavoriteCoffee coffee) async {
    final box = await storage.favoriteCoffeeBox;
    final key = const Uuid().v4();
    _keysMap.putIfAbsent(
      coffee.bytes,
      () => key,
    );

    await box.put(key, coffee);
  }

  /// Unfavorites, and deletes from cache, the coffee image data on
  /// local storage
  Future<void> unfavoriteCoffee(FavoriteCoffee coffee) async {
    final box = await storage.favoriteCoffeeBox;
    final key = _keysMap[coffee.bytes];

    await box.delete(key);
    _keysMap.remove(key);
  }

  /// Obtain all favorite coffee from local storage
  Future<List<FavoriteCoffee>> getFavoriteCoffees() async {
    final box = await storage.favoriteCoffeeBox;

    return box.values.toList();
  }

  /// Verify if the coffee bytes is cached on local storage
  Future<bool> isCoffeeFavorite(FavoriteCoffee coffee) async {
    final box = await storage.favoriteCoffeeBox;
    final key = _keysMap[coffee.bytes];
    final favoriteCoffee = box.get(key);

    return favoriteCoffee != null;
  }
}
