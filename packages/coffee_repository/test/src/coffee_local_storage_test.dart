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
  final dataBytes = Uint8List.fromList([1, 2, 3, 4]);
  final favoriteCoffee = FavoriteCoffee(url: dataUrl, bytes: dataBytes);

  group('CoffeeLocalStorage', () {
    late KeyValueStorage storage;
    late Box<FavoriteCoffee> box;
    late CoffeeLocalStorage sut;

    setUpAll(() {
      registerFallbackValue(Uint8List.fromList([0]));
      registerFallbackValue(
        FavoriteCoffee(url: '', bytes: Uint8List.fromList([0])),
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

      when(() => box.values).thenReturn(<FavoriteCoffee>[
        FavoriteCoffee(url: '', bytes: Uint8List.fromList([0])),
        FavoriteCoffee(url: 'http', bytes: Uint8List.fromList([1])),
        FavoriteCoffee(url: 'html', bytes: Uint8List.fromList([2])),
      ]);

      when(() => storage.favoriteCoffeeBox)
          .thenAnswer((invocation) async => box);

      sut = CoffeeLocalStorage(storage: storage);
    });

    test('stores a FavoriteCoffee model on cache', () async {
      await sut.favoriteCoffee(favoriteCoffee);

      verify(() => box.put(favoriteCoffee.url, favoriteCoffee));
    });

    test('removes a FavoriteCoffee model from cache', () async {
      await sut.unfavoriteCoffee(favoriteCoffee.url);

      verify(() => box.delete(favoriteCoffee.url));
    });

    test('returns a FavoriteCoffee model list from cache', () async {
      final coffees = await sut.getFavoriteCoffees();

      expect(
        coffees,
        equals(<FavoriteCoffee>[
          FavoriteCoffee(url: '', bytes: Uint8List.fromList([0])),
          FavoriteCoffee(url: 'http', bytes: Uint8List.fromList([1])),
          FavoriteCoffee(url: 'html', bytes: Uint8List.fromList([2])),
        ]),
      );
    });

    test('returns if a FavoriteCoffee model is stored or not', () async {
      final isFavoriteBeforeCaching =
          await sut.isCoffeeFavorite(favoriteCoffee.url);

      expect(isFavoriteBeforeCaching, isFalse);

      when(() => box.get(any<Uint8List>())).thenReturn(favoriteCoffee);

      final isFavoriteAfterCaching =
          await sut.isCoffeeFavorite(favoriteCoffee.url);

      expect(isFavoriteAfterCaching, isTrue);
    });
  });
}
