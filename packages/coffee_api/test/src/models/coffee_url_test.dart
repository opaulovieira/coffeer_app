import 'package:coffee_api/coffee_api.dart';
import 'package:test/test.dart';

void main() {
  group('CoffeeUrl', () {
    const data = <String, Object?>{
      'file': 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg'
    };

    const coffeeUrl = CoffeeUrl(
      url: 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg',
    );

    test('supports value equality.', () {
      const coffeeUrl2 = CoffeeUrl(
        url: 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg',
      );

      expect(coffeeUrl, equals(coffeeUrl2));
    });

    test('can be converted to json', () {
      expect(coffeeUrl.toJson(), equals(data));
    });

    test('can be obtained from json', () {
      final coffeeUrlFrom = CoffeeUrl.fromJson(data);

      expect(coffeeUrl, equals(coffeeUrlFrom));
    });
  });
}
