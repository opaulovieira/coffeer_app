import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/showcase/showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('ShowcaseDialog', () {
    group('ToggleFavoriteShowcaseDialog', () {
      testWidgets('inflates the toggle favorite dialog', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  openToggleFavoriteShowcaseDialog(
                    context,
                    coffee: const Coffee(id: 'id', url: 'url'),
                    onToggleAction: () {},
                  );
                },
                child: const Text('test'),
              );
            },
          ),
        );

        final buttonFinder = find.text('test');
        await tester.tap(buttonFinder);

        await tester.pump();

        expect(find.byType(ShowcaseDialog), findsOneWidget);
      });

      testWidgets('toggles the icon state', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  openToggleFavoriteShowcaseDialog(
                    context,
                    coffee: const Coffee(id: 'id', url: 'url'),
                    onToggleAction: () {},
                  );
                },
                child: const Text('test'),
              );
            },
          ),
        );

        final buttonFinder = find.text('test');
        await tester.tap(buttonFinder);

        await tester.pump();

        final iconFinder = find.byIcon(Icons.favorite_outline_rounded);
        expect(iconFinder, findsOneWidget);

        await tester.tap(iconFinder);

        await tester.pump();

        final toggledIconFinder = find.byIcon(Icons.favorite_rounded);
        expect(toggledIconFinder, findsOneWidget);
      });
    });

    group('UnfavoriteShowcaseDialog', () {
      testWidgets('inflates the toggle favorite dialog', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  openUnfavoriteShowcaseDialog(
                    context,
                    coffee: const Coffee(id: 'id', url: 'url'),
                    onUnfavorite: () {},
                  );
                },
                child: const Text('test'),
              );
            },
          ),
        );

        final buttonFinder = find.text('test');
        await tester.tap(buttonFinder);

        await tester.pump();

        expect(find.byType(ShowcaseDialog), findsOneWidget);
      });
    });
  });
}
