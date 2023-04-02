import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'favorite_coffee.g.dart';

/// {@template coffee}
/// A favorite coffee object.
/// {@endtemplate}
@HiveType(typeId: 0)
class FavoriteCoffee extends Equatable {
  /// {@macro coffee}
  const FavoriteCoffee({
    required this.id,
    required this.url,
  });

  /// The url used to fetch this [FavoriteCoffee] image
  @HiveField(0)
  final String url;

  /// The identification for this [FavoriteCoffee]
  @HiveField(1)
  final String id;

  @override
  List<Object?> get props => [id, url];
}
