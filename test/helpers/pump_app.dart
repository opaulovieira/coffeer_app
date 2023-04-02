import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

CoffeeRepository _buildCoffeeRepositoryMock() {
  final repository = _MockCoffeeRepository();

  when(repository.getRandomCoffeeUrl).thenAnswer((invocation) async => '');
  when(() => repository.isCoffeeFavorite(any()))
      .thenAnswer((invocation) async => false);
  when(repository.getFavoriteCoffees).thenAnswer((invocation) async => []);

  return repository;
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    CoffeeRepository? coffeeRepository,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CoffeeRepository>(
            create: (context) =>
                coffeeRepository ?? _buildCoffeeRepositoryMock(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
