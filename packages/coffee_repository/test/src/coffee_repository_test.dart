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
  const coffee = Coffee(id: '0', url: dataUrl);

  group('CoffeeRepository', () {
    late CoffeeApi coffeeApi;
    late CoffeeLocalStorage coffeeLocalStorage;
    late CoffeeRepository sut;

    setUpAll(() {
      registerFallbackValue(Uint8List.fromList([0]));
      registerFallbackValue(
        FavoriteCoffee(url: '', id: '0'),
      );
    });

    setUp(() {
      coffeeApi = _MockCoffeeApi();
      coffeeLocalStorage = _MockCoffeeLocalStorage();

      when(() => coffeeApi.getCoffeeUrlHolder())
          .thenAnswer((invocation) async => const CoffeeUrl(url: dataUrl));

      when(() => coffeeApi.getCoffeeBytes())
          .thenAnswer((invocation) async => Uint8List.fromList([1, 2, 3, 4]));

      when(() => coffeeLocalStorage.isCoffeeFavorite(any()))
          .thenAnswer((invocation) async => false);

      when(() => coffeeLocalStorage.getFavoriteCoffees())
          .thenAnswer((invocation) async {
        return const <FavoriteCoffee>[
          FavoriteCoffee(url: '', id: '0'),
          FavoriteCoffee(url: 'http', id: '0'),
          FavoriteCoffee(url: 'html', id: '0'),
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

      final isFavorite = await sut.isCoffeeFavorite(coffee.id);

      expect(isFavorite, isTrue);
    });

    test(
        'returns a Coffee model list from cache, '
        'they should have isFavorite flag as true', () async {
      final coffees = await sut.getFavoriteCoffees();

      expect(
        coffees,
        equals(const <Coffee>[
          Coffee(url: '', id: '0', isFavorite: true),
          Coffee(url: 'http', id: '1', isFavorite: true),
          Coffee(url: 'html', id: '2', isFavorite: true),
        ]),
      );
    });

    test('stores a Coffee model on cache', () async {
      await sut.favoriteCoffee(Coffee(id: '0', url: dataUrl));

      verify(() {
        return coffeeLocalStorage.favoriteCoffee(
          FavoriteCoffee(id: '0', url: dataUrl),
        );
      });
    });

    test('removes a Coffee model from cache', () async {
      await sut.unfavoriteCoffee(coffee.id);

      verify(() {
        return coffeeLocalStorage.unfavoriteCoffee(coffee.id);
      });
    });
  });
}
