import 'package:coffeer_app/app/app.dart';
import 'package:coffeer_app/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    LiveTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpWidget(const App());

      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
