import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/home/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('HomeBloc', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = _MockCoffeeRepository();

      when(() => coffeeRepository.getRandomCoffeeUrl())
          .thenAnswer((invocation) async => '1');
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
          const Success(coffeeUrlList: ['1'])
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
          const Success(coffeeUrlList: ['1'])
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
          const Success(coffeeUrlList: ['1', '3', '5', '7', '9'])
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
            FailedRequestException(
              StateError('FailedRequestException error'),
              StackTrace.empty,
            ),
          );
        },
        build: () => HomeBloc(coffeeRepository: coffeeRepository),
        act: (bloc) => bloc.add(const RequestImages()),
        expect: () => [
          isA<Error>().having(
            (error) => error.error,
            'FailedRequestException error data',
            isA<StateError>(),
          )
        ],
      );
    });
  });
}
