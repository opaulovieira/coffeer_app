import 'dart:typed_data';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const dataUrl = 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg';
  final dataBytes = Uint8List.fromList([1, 2, 3, 4]);

  group('Coffee', () {
    final coffee = Coffee(url: dataUrl, bytes: dataBytes, isFavorite: true);

    test(
        'supports value equality, which depends only on bytes and isFavorite '
        'property', () {
      final coffee2 = Coffee(url: dataUrl, bytes: dataBytes, isFavorite: true);
      final coffee3 = Coffee(bytes: dataBytes, isFavorite: true);
      final coffee4 = Coffee(url: dataUrl, bytes: dataBytes);

      expect(coffee, equals(coffee2));
      expect(coffee, equals(coffee3));
      expect(coffee == coffee4, isFalse);
    });
  });
}
