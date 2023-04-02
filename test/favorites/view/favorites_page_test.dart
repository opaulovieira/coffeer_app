import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockFavoritesBloc extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

void main() {
  group('FavoritesPage', () {
    testWidgets('renders FavoritesView', (tester) async {
      await tester.pumpApp(const FavoritesPage());

      expect(find.byType(FavoritesView), findsOneWidget);
    });
  });

  group('FavoritesView', () {
    late FavoritesBloc bloc;

    setUp(() {
      bloc = _MockFavoritesBloc();
    });

    testWidgets('renders Loading state', (tester) async {
      when(() => bloc.state).thenReturn(const Loading());

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const FavoritesView()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders Empty state', (tester) async {
      when(() => bloc.state).thenReturn(const Empty());

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const FavoritesView()),
      );

      expect(
        find.text('It seems that you have not favorited anything'),
        findsOneWidget,
      );
    });

    testWidgets('renders Idle state', (tester) async {
      when(() => bloc.state).thenReturn(
        const Idle(
          coffeeList: <Coffee>[Coffee(id: '1', url: '')],
        ),
      );

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const FavoritesView()),
      );

      expect(
        find.byType(Image),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows a confirmation dialog when tries to unfavorite an image '
        'and emits Unfavorite event if confirmed', (tester) async {
      const initialState = Idle(
        coffeeList: <Coffee>[Coffee(id: '1', url: 'url')],
      );

      whenListen(
        bloc,
        Stream.value(
          initialState.copyWith(
            action: const RequestUnfavoriteConfirmation(key: 'url'),
          ),
        ),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const FavoritesView()),
      );

      await tester.pump();

      expect(find.byType(Dialog), findsOneWidget);

      final confirmationButtonFinder = find.descendant(
        of: find.byType(Dialog),
        matching: find.text('Confirm'),
      );
      expect(confirmationButtonFinder, findsOneWidget);

      await tester.tap(confirmationButtonFinder);

      verify(() => bloc.add(const Unfavorite(id: 'url')));
    });
  });
}
