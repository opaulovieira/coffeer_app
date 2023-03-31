import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/carousel/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('CarouselView', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = _MockCoffeeRepository();

      when(() => coffeeRepository.isCoffeeFavorite(any()))
          .thenAnswer((invocation) async => false);
    });

    testWidgets('renders CarouselItem', (tester) async {
      await tester.pumpApp(
        RepositoryProvider<CoffeeRepository>(
          create: (context) => coffeeRepository,
          child: const CarouselView(urlList: ['']),
        ),
      );

      expect(find.byType(CarouselItem), findsOneWidget);
    });

    testWidgets('renders try again button', (tester) async {
      await tester.pumpApp(
        RepositoryProvider<CoffeeRepository>(
          create: (context) => coffeeRepository,
          child: CarouselView(
            urlList: const [''],
            onRequestMore: () {},
          ),
        ),
      );

      expect(
        find.byIcon(Icons.refresh_rounded),
        findsOneWidget,
      );
    });
  });

  // Due to CachedNetworkImage not being able to test its imageBuilder
  // I will postpone the CarouselItem tests until I find a better solution
  // group('CarouselItem', () {});
}
