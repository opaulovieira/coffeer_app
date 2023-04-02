import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_storage/key_value_storage.dart';

void main() {
  const dataUrl = 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg';

  group('FavoriteCoffee', () {
    const coffee = FavoriteCoffee(url: dataUrl, id: '0');

    test('supports value equality', () {
      const coffee2 = FavoriteCoffee(url: dataUrl, id: '0');
      const coffee3 = FavoriteCoffee(url: '', id: '0');

      expect(coffee, equals(coffee2));
      expect(coffee == coffee3, isFalse);
    });
  });
}
