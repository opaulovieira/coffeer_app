import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/home/bloc/home_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('HomeBloc', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      registerFallbackValue(const Coffee(id: '1', url: '1'));

      coffeeRepository = _MockCoffeeRepository();

      when(() => coffeeRepository.getRandomCoffeeUrl())
          .thenAnswer((invocation) async => '1');

      when(() => coffeeRepository.isCoffeeFavorite(any()))
          .thenAnswer((invocation) async => false);

      when(() => coffeeRepository.favoriteCoffee(any()))
          .thenAnswer((invocation) async {});

      when(() => coffeeRepository.unfavoriteCoffee(any()))
          .thenAnswer((invocation) async {});

      when(() => coffeeRepository.getFavoriteCoffees())
          .thenAnswer((invocation) async {
        return const <Coffee>[];
      });
    });

    test('initial state is Loading', () {
      expect(
        HomeBloc(coffeeRepository: coffeeRepository).state,
        const Loading(),
      );
    });

    group('on TryAgain event', () {
      blocTest<HomeBloc, HomeState>(
        'emits [Loading, Success] state',
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const TryAgain()),
        expect: () => [
          const Loading(),
          isA<Success>().having(
            (success) => success.coffeeList.single,
            'Coffee',
            predicate<Coffee>((coffee) => coffee.url == '1'),
          )
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits [Loading, Error] state when getRandomCoffeeUrl throws an error',
        setUp: () {
          when(() => coffeeRepository.getRandomCoffeeUrl())
              .thenThrow(Exception());
        },
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const TryAgain()),
        expect: () => [const Loading(), isA<Error>()],
      );
    });

    group('on RequestImages event', () {
      blocTest<HomeBloc, HomeState>(
        'emits Success state with n items defined by initialCoffeeQuantity',
        build: () => HomeBloc(
          coffeeRepository: coffeeRepository,
          initialCoffeeQuantity: 1,
        ),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [
          isA<Success>().having(
            (success) => success.coffeeList.single,
            'Coffee',
            predicate<Coffee>((coffee) => coffee.url == '1'),
          )
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits Success state with items reflecting storage favorite state',
        setUp: () {
          when(() => coffeeRepository.getFavoriteCoffees())
              .thenAnswer((invocation) async {
            return const <Coffee>[
              Coffee(id: '1', url: '1'),
              Coffee(id: '2', url: '2'),
              Coffee(id: '3', url: '3'),
            ];
          });
        },
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [
          isA<Success>().having(
            (success) => success.coffeeList.single,
            'Coffee',
            predicate<Coffee>(
              (coffee) => coffee.url == '1' && coffee.isFavorite,
            ),
          )
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits Success state with non repeated items',
        setUp: () {
          var randomUrlCount = 0;

          when(() => coffeeRepository.getRandomCoffeeUrl())
              .thenAnswer((invocation) async {
            final previousRandomUrlCount = randomUrlCount;
            randomUrlCount = randomUrlCount + 1;

            if (randomUrlCount.isEven) {
              return previousRandomUrlCount.toString();
            } else {
              return randomUrlCount.toString();
            }
          });
        },
        build: () => HomeBloc(
          coffeeRepository: coffeeRepository,
          initialCoffeeQuantity: 10,
        ),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [
          isA<Success>().having(
            (success) => success.coffeeList,
            'Coffee list',
            predicate<List<Coffee>>((coffeeList) {
              final urlList = coffeeList.map((coffee) => coffee.url).toList();

              return urlList.equals(['1', '3', '5', '7', '9']);
            }),
          )
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits Error state when getRandomCoffeeUrl throws an error',
        setUp: () {
          when(() => coffeeRepository.getRandomCoffeeUrl())
              .thenThrow(Exception());
        },
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [isA<Error>()],
      );

      blocTest<HomeBloc, HomeState>(
        'emits Error state with FailedRequestException error data when'
        ' getRandomCoffeeUrl throws a FailedRequestException',
        setUp: () {
          when(() => coffeeRepository.getRandomCoffeeUrl()).thenThrow(
            const FailedRequestException(),
          );
        },
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [const Error(detail: ErrorDetail.unexpected)],
      );
    });

    group('on Favorite event', () {
      blocTest<HomeBloc, HomeState>(
        're-emits Success state with the updated list',
        seed: () => const Success(coffeeList: [Coffee(id: 'id1', url: 'url1')]),
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(
          const Favorite(
            coffee: Coffee(id: 'id1', url: 'url1'),
          ),
        ),
        expect: () => [
          const Success(
            coffeeList: [Coffee(id: 'id1', url: 'url1', isFavorite: true)],
          ),
        ],
      );
    });

    group('on Unfavorite event', () {
      blocTest<HomeBloc, HomeState>(
        're-emits Success state with the updated list',
        seed: () => const Success(
          coffeeList: [Coffee(id: 'id1', url: 'url1', isFavorite: true)],
        ),
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(
          const Unfavorite(id: 'id1'),
        ),
        expect: () => [
          const Success(
            coffeeList: [Coffee(id: 'id1', url: 'url1')],
          ),
        ],
      );
    });
  });
}
