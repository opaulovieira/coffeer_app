import 'dart:typed_data';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockKeyValueStorage extends Mock implements KeyValueStorage {}

class _MockFavoriteBox extends Mock implements Box<FavoriteCoffee> {}

void main() {
  const dataUrl = 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg';
  const favoriteCoffee = FavoriteCoffee(url: dataUrl, id: '0');

  group('CoffeeLocalStorage', () {
    late KeyValueStorage storage;
    late Box<FavoriteCoffee> box;
    late CoffeeLocalStorage sut;

    setUpAll(() {
      registerFallbackValue(Uint8List.fromList([0]));
      registerFallbackValue(
        const FavoriteCoffee(url: '', id: '0'),
      );
    });

    setUp(() {
      storage = _MockKeyValueStorage();
      box = _MockFavoriteBox();

      when(() => box.put(any<Uint8List>(), any()))
          .thenAnswer((invocation) async {});

      when(() => box.delete(any<Uint8List>()))
          .thenAnswer((invocation) async {});

      when(() => box.get(any<Uint8List>())).thenReturn(null);

      when(() => box.values).thenReturn(const <FavoriteCoffee>[
        FavoriteCoffee(url: '', id: '0'),
        FavoriteCoffee(url: 'http', id: '1'),
        FavoriteCoffee(url: 'html', id: '2'),
      ]);

      when(() => storage.favoriteCoffeeBox)
          .thenAnswer((invocation) async => box);

      sut = CoffeeLocalStorage(storage: storage);
    });

    test('stores a FavoriteCoffee model on cache', () async {
      await sut.favoriteCoffee(favoriteCoffee);

      verify(() => box.put(favoriteCoffee.id, favoriteCoffee));
    });

    test('removes a FavoriteCoffee model from cache', () async {
      await sut.unfavoriteCoffee(favoriteCoffee.id);

      verify(() => box.delete(favoriteCoffee.id));
    });

    test('returns a FavoriteCoffee model list from cache', () async {
      final coffees = await sut.getFavoriteCoffees();

      expect(
        coffees,
        equals(const <FavoriteCoffee>[
          FavoriteCoffee(url: '', id: '0'),
          FavoriteCoffee(url: 'http', id: '1'),
          FavoriteCoffee(url: 'html', id: '2'),
        ]),
      );
    });

    test('returns if a FavoriteCoffee model is stored or not, based on id',
        () async {
      final isFavoriteBeforeCaching =
          await sut.isCoffeeFavorite(favoriteCoffee.id);

      expect(isFavoriteBeforeCaching, isFalse);

      when(() => box.get(any<Uint8List>())).thenReturn(favoriteCoffee);

      final isFavoriteAfterCaching =
          await sut.isCoffeeFavorite(favoriteCoffee.id);

      expect(isFavoriteAfterCaching, isTrue);
    });

    test('returns if a FavoriteCoffee model is stored or not, based on url',
        () async {
      final isFavoriteBeforeCaching =
          await sut.isCoffeeFavoriteFromUrl(favoriteCoffee.url);

      expect(isFavoriteBeforeCaching, isFalse);

      when(() => box.get(any<Uint8List>())).thenReturn(favoriteCoffee);

      final isFavoriteAfterCaching =
          await sut.isCoffeeFavorite(favoriteCoffee.url);

      expect(isFavoriteAfterCaching, isTrue);
    });
  });
}
