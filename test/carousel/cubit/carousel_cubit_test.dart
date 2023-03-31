import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/carousel/cubit/carousel_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('CarouselCubit', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      registerFallbackValue(Coffee(bytes: Uint8List.fromList([1]), url: ''));

      coffeeRepository = _MockCoffeeRepository();

      when(() => coffeeRepository.isCoffeeFavorite(any()))
          .thenAnswer((invocation) async => false);

      when(() => coffeeRepository.favoriteCoffee(any()))
          .thenAnswer((invocation) async {});

      when(() => coffeeRepository.unfavoriteCoffee(any()))
          .thenAnswer((invocation) async {});
    });

    test('initial state is false', () {
      when(() => coffeeRepository.isCoffeeFavorite(any()))
          .thenAnswer((invocation) async => true);

      expect(
        CarouselCubit(coffeeRepository: coffeeRepository, url: '').state,
        false,
      );
    });

    blocTest<CarouselCubit, bool>(
      'emits the url storage state after instantiation',
      setUp: () {
        when(() => coffeeRepository.isCoffeeFavorite(any()))
            .thenAnswer((invocation) async => false);
      },
      build: () => CarouselCubit(coffeeRepository: coffeeRepository, url: ''),
      expect: () => <bool>[false],
    );

    group('favorite', () {
      blocTest<CarouselCubit, bool>(
        'emits nothing when bytes is null',
        build: () => CarouselCubit(coffeeRepository: coffeeRepository, url: ''),
        act: (cubit) => cubit.favorite(Future<Uint8List?>.value()),
        expect: () => <bool>[false],
      );

      blocTest<CarouselCubit, bool>(
        'emits true after storing the coffee',
        build: () => CarouselCubit(coffeeRepository: coffeeRepository, url: ''),
        act: (cubit) =>
            cubit.favorite(Future<Uint8List?>.value(Uint8List.fromList([1]))),
        expect: () => <bool>[false, true],
      );
    });

    group('unfavorite', () {
      blocTest<CarouselCubit, bool>(
        'emits false after removing the coffee from storage',
        setUp: () {
          when(() => coffeeRepository.isCoffeeFavorite(any()))
              .thenAnswer((invocation) async => true);
        },
        build: () => CarouselCubit(coffeeRepository: coffeeRepository, url: ''),
        act: (cubit) => cubit.unfavorite(),
        expect: () => <bool>[true, false],
      );
    });
  });
}
