import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/favorites/bloc/favorites_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('FavoritesBloc', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = _MockCoffeeRepository();

      when(() => coffeeRepository.getFavoriteCoffees())
          .thenAnswer((invocation) async {
        return <Coffee>[];
      });

      when(() => coffeeRepository.unfavoriteCoffee(any()))
          .thenAnswer((invocation) async {});
    });

    test('initial state is Loading', () {
      expect(
        FavoritesBloc(coffeeRepository: coffeeRepository).state,
        const Loading(),
      );
    });

    group('on RequestImages event', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits Empty state when there is no favorite image stored',
        build: () => FavoritesBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [const Empty()],
        verify: (bloc) {
          return verify(() => coffeeRepository.getFavoriteCoffees());
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits Idle state when there is a favorite image stored',
        setUp: () {
          when(() => coffeeRepository.getFavoriteCoffees())
              .thenAnswer((invocation) async {
            return const <Coffee>[
              Coffee(id: '1', url: 'url'),
            ];
          });
        },
        build: () => FavoritesBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [
          const Idle(
            coffeeList: [Coffee(id: '1', url: 'url')],
          )
        ],
        verify: (bloc) {
          return verify(() => coffeeRepository.getFavoriteCoffees());
        },
      );
    });

    group('on RequestUnfavorite event', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'updates the Idle state with request unfavorite action',
        setUp: () {
          when(() => coffeeRepository.getFavoriteCoffees())
              .thenAnswer((invocation) async {
            return const <Coffee>[
              Coffee(id: '1', url: 'url'),
            ];
          });
        },
        seed: () => const Idle(
          coffeeList: [Coffee(id: '1', url: 'url')],
        ),
        build: () => FavoritesBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestUnfavorite(id: '1')),
        expect: () => [
          const Idle(
            coffeeList: [Coffee(id: '1', url: 'url')],
            action: RequestUnfavoriteConfirmation(key: '1'),
          )
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits nothing when state is not Idle',
        seed: () => const Empty(),
        build: () => FavoritesBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestUnfavorite(id: '1')),
        expect: () => const <FavoritesState>[],
      );
    });

    group('on Unfavorite event', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'updates the Idle state with the new favorites list',
        seed: () => const Idle(
          coffeeList: [
            Coffee(id: '12', url: 'url'),
            Coffee(id: '21', url: 'lru'),
          ],
        ),
        build: () => FavoritesBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const Unfavorite(id: '12')),
        expect: () => [
          const Idle(
            coffeeList: [Coffee(id: '21', url: 'lru')],
          )
        ],
        verify: (bloc) {
          return verify(() => coffeeRepository.unfavoriteCoffee('12'));
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits Empty state when unfavorites the last image',
        seed: () => const Idle(
          coffeeList: [Coffee(id: '12', url: 'url')],
        ),
        build: () => FavoritesBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const Unfavorite(id: '12')),
        expect: () => [const Empty()],
        verify: (bloc) {
          return verify(() => coffeeRepository.unfavoriteCoffee('12'));
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits nothing when state is not Idle',
        seed: () => const Empty(),
        build: () => FavoritesBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const Unfavorite(id: '12')),
        expect: () => <FavoritesState>[],
        verify: (bloc) {
          return verifyNever(() => coffeeRepository.unfavoriteCoffee('12'));
        },
      );
    });
  });
}
