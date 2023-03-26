// ignore_for_file: prefer_const_constructors
import 'package:key_value_storage/key_value_storage.dart';
import 'package:test/test.dart';

void main() {
  group('KeyValueStorage', () {
    test('can be instantiated', () {
      expect(KeyValueStorage(), isNotNull);
    });
  });
}
