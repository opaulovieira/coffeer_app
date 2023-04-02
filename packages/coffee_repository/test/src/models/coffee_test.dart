import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const dataUrl = 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg';

  group('Coffee', () {
    const coffee = Coffee(url: dataUrl, id: '0', isFavorite: true);

    test('supports value equality', () {
      const coffee2 = Coffee(url: dataUrl, id: '0', isFavorite: true);
      const coffee4 = Coffee(url: dataUrl, id: '0');

      expect(coffee, equals(coffee2));
      expect(coffee == coffee4, isFalse);
    });

    test('supports copyWith pattern', () {
      final coffee2 = coffee.copyWith(isFavorite: false);

      expect(coffee2, equals(const Coffee(url: dataUrl, id: '0')));
    });
  });
}
