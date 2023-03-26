// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockHive extends Mock implements HiveInterface {}

class _MockBox<T> extends Mock implements Box<T> {}

class _MockTypeAdapter<T> extends Mock implements TypeAdapter<T> {}

class _FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => './';

  @override
  Future<String?> getTemporaryPath() async => './';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Box<Coffee> favoriteCoffeeImagesBox;
  late HiveInterface hive;
  late KeyValueStorage sut;

  group('KeyValueStorage', () {
    setUp(() {
      PathProviderPlatform.instance = _FakePathProviderPlatform();

      hive = _MockHive();
      favoriteCoffeeImagesBox = _MockBox<Coffee>();

      registerFallbackValue(_MockTypeAdapter<Coffee>());

      when(
        () => hive.registerAdapter<Coffee>(
          any(),
          internal: any(named: 'internal'),
          override: any(named: 'override'),
        ),
      ).thenAnswer((invocation) {});

      when(() => hive.isBoxOpen(any())).thenReturn(false);

      when(() {
        return hive.openBox<Coffee>(
          any(),
          encryptionCipher: any(named: 'encryptionCipher'),
          keyComparator: any(named: 'keyComparator'),
          compactionStrategy: any(named: 'compactionStrategy'),
          crashRecovery: any(named: 'crashRecovery'),
          path: any(named: 'path'),
          bytes: any(named: 'bytes'),
          collection: any(named: 'collection'),
        );
      }).thenAnswer((invocation) async => favoriteCoffeeImagesBox);
      when(() => hive.box<Coffee>(any())).thenReturn(favoriteCoffeeImagesBox);

      sut = KeyValueStorage(hive: hive);
    });

    test('can be instantiated', () {
      expect(sut, isNotNull);
    });

    test('returns a Box in case it is already open', () async {
      when(() => hive.isBoxOpen(any())).thenReturn(true);

      final box = await sut.favoriteCoffeeImagesBox;

      expect(box, equals(favoriteCoffeeImagesBox));
    });

    test('creates a Box in case it is not open, and returns it', () async {
      when(() => hive.isBoxOpen(any())).thenReturn(false);

      final box = await sut.favoriteCoffeeImagesBox;

      expect(box, equals(favoriteCoffeeImagesBox));
    });
  });
}
