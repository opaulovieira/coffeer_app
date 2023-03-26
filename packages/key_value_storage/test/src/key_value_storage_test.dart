// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_storage/key_value_storage.dart';

void main() {
  group('KeyValueStorage', () {
    test('can be instantiated', () {
      expect(KeyValueStorage(), isNotNull);
    });
  });
}
