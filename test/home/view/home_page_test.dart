import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/home/home.dart';
import 'package:coffeer_app/home/view/widgets/carousel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('HomePage', () {
    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(const HomePage());

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late HomeBloc bloc;

    setUp(() {
      bloc = _MockHomeBloc();
    });

    testWidgets('renders loading state', (tester) async {
      const state = Loading();

      when(() => bloc.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const HomeView()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders success state', (tester) async {
      const state = Success(coffeeList: [Coffee(id: 'id', url: 'url')]);

      when(() => bloc.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const HomeView()),
      );

      expect(find.byType(CarouselView), findsOneWidget);
    });

    testWidgets('renders error state', (tester) async {
      const state = Error(detail: ErrorDetail.unexpected);

      when(() => bloc.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const HomeView()),
      );

      expect(
        find.text('Ops, sorry... \nSomething went wrong!'),
        findsOneWidget,
      );
    });

    testWidgets('emits TryAgain event when tapping on try again button',
        (tester) async {
      const state = Error(detail: ErrorDetail.internet);

      when(() => bloc.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const HomeView()),
      );

      final tryAgainButtonFinder =
          find.widgetWithText(ElevatedButton, 'Try again');
      await tester.tap(tryAgainButtonFinder);

      verify(() => bloc.add(const TryAgain()));
    });

    testWidgets('emits RequestImages event when tapping on request more button',
        (tester) async {
      const state = Success(coffeeList: [Coffee(id: 'id', url: 'url')]);

      when(() => bloc.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider(create: (context) => bloc, child: const HomeView()),
      );

      final requestMoreButtonFinder = find.byIcon(Icons.refresh_rounded);
      await tester.tap(requestMoreButtonFinder);

      verify(() => bloc.add(const RequestImages()));
    });
  });
}
