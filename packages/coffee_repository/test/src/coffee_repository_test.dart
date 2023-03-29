// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoffeeApi extends Mock implements CoffeeApi {}

class _MockCoffeeLocalStorage extends Mock implements CoffeeLocalStorage {}

void main() {
  const dataUrl = 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg';
  final dataBytes = Uint8List.fromList([1, 2, 3, 4]);
  final coffee = Coffee(bytes: dataBytes, url: dataUrl);

  group('CoffeeRepository', () {
    late CoffeeApi coffeeApi;
    late CoffeeLocalStorage coffeeLocalStorage;
    late CoffeeRepository sut;

    setUpAll(() {
      registerFallbackValue(Uint8List.fromList([0]));
      registerFallbackValue(
        FavoriteCoffee(url: '', bytes: Uint8List.fromList([0])),
      );
    });

    setUp(() {
      coffeeApi = _MockCoffeeApi();
      coffeeLocalStorage = _MockCoffeeLocalStorage();

      when(() => coffeeApi.getCoffeeUrlHolder())
          .thenAnswer((invocation) async => const CoffeeUrl(url: dataUrl));

      when(() => coffeeApi.getCoffeeBytes())
          .thenAnswer((invocation) async => dataBytes);

      when(() => coffeeLocalStorage.isCoffeeFavorite(any()))
          .thenAnswer((invocation) async => false);

      when(() => coffeeLocalStorage.getFavoriteCoffees())
          .thenAnswer((invocation) async {
        return <FavoriteCoffee>[
          FavoriteCoffee(url: '', bytes: Uint8List.fromList([0])),
          FavoriteCoffee(url: 'http', bytes: Uint8List.fromList([1])),
          FavoriteCoffee(url: 'html', bytes: Uint8List.fromList([2])),
        ];
      });

      when(() => coffeeLocalStorage.favoriteCoffee(any()))
          .thenAnswer((invocation) async {});

      when(() => coffeeLocalStorage.unfavoriteCoffee(any()))
          .thenAnswer((invocation) async {});

      sut = CoffeeRepository(api: coffeeApi, storage: coffeeLocalStorage);
    });

    test('fetchs a url for later request of a Coffee', () async {
      final url = await sut.getRandomCoffeeUrl();

      expect(url, equals(dataUrl));
    });

    test('verifies if a Coffee is favorite', () async {
      when(() => coffeeLocalStorage.isCoffeeFavorite(any()))
          .thenAnswer((invocation) async => true);

      final isFavorite = await sut.isCoffeeFavorite(coffee);

      expect(isFavorite, isTrue);
    });

    test(
        'returns a Coffee model list from cache, '
        'they should have isFavorite flag as true', () async {
      final coffees = await sut.getFavoriteCoffees();

      expect(
        coffees,
        equals(<Coffee>[
          Coffee(url: '', bytes: Uint8List.fromList([0]), isFavorite: true),
          Coffee(url: 'http', bytes: Uint8List.fromList([1]), isFavorite: true),
          Coffee(url: 'html', bytes: Uint8List.fromList([2]), isFavorite: true),
        ]),
      );
    });

    test('stores a Coffee model on cache', () async {
      await sut.favoriteCoffee(coffee);

      verify(() {
        return coffeeLocalStorage
            .favoriteCoffee(FavoriteCoffee(bytes: dataBytes, url: dataUrl));
      });
    });

    test('removes a Coffee model from cache', () async {
      await sut.unfavoriteCoffee(coffee);

      verify(() {
        return coffeeLocalStorage
            .unfavoriteCoffee(FavoriteCoffee(bytes: dataBytes, url: dataUrl));
      });
    });
  });
}
