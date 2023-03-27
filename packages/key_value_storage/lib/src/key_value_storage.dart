import 'package:hive/hive.dart';
import 'package:key_value_storage/src/models/favorite_coffee.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

/// {@template key_value_storage}
/// Wraps [Hive] so that we can register all adapters and manage all keys in a
/// single place.
///
/// To use this class, simply unwrap one of its exposed boxes, like
/// [favoriteCoffeeBox], and execute operations in it, for example:
///
/// ```
/// (await favoriteCoffeeImagesBox).clear();
/// {@endtemplate}
class KeyValueStorage {
  /// {@macro key_value_storage}
  KeyValueStorage({
    @visibleForTesting HiveInterface? hive,
  }) : _hive = hive ?? Hive {
    try {
      _hive.registerAdapter<FavoriteCoffee>(FavoriteCoffeeAdapter());
    } catch (_) {
      throw Exception(
        "You shouldn't have more than one [KeyValueStorage] instance in your "
        'project',
      );
    }
  }

  static const _favoriteCoffeeBoxKey = 'favorite-coffee-box';

  final HiveInterface _hive;

  /// Box which caches all favorite coffee images
  ///
  /// Because not all images have an url to later fetching, this box doesn't
  /// cache temporarily, otherwise, the OS would delete the image at any time.
  Future<Box<FavoriteCoffee>> get favoriteCoffeeBox {
    return _openHiveBox(_favoriteCoffeeBoxKey, isTemporary: false);
  }

  Future<Box<T>> _openHiveBox<T>(
    String boxKey, {
    required bool isTemporary,
  }) async {
    if (_hive.isBoxOpen(boxKey)) {
      return _hive.box(boxKey);
    } else {
      final directory = await (isTemporary
          ? getTemporaryDirectory()
          : getApplicationDocumentsDirectory());
      return _hive.openBox<T>(
        boxKey,
        path: directory.path,
      );
    }
  }
}
