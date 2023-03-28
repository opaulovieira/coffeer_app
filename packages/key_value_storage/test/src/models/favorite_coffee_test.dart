import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_storage/key_value_storage.dart';

void main() {
  const dataUrl = 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg';
  final dataBytes = Uint8List.fromList([1, 2, 3, 4]);

  group('FavoriteCoffee', () {
    final coffee = FavoriteCoffee(url: dataUrl, bytes: dataBytes);

    test('supports value equality', () {
      final coffee2 = FavoriteCoffee(url: dataUrl, bytes: dataBytes);
      final coffee3 = FavoriteCoffee(bytes: dataBytes);

      expect(coffee, equals(coffee2));
      expect(coffee == coffee3, isFalse);
    });
  });
}
