import 'package:coffee_api/coffee_api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee_url.g.dart';

@JsonSerializable()

/// {@template coffee_url}
/// A URL holder for [CoffeeApi]
///
/// Example:
/// ```json
/// {
///   "file": "https://coffee.alexflipnote.dev/9hz2zWab3xw_coffee.jpg"
/// }
/// ```
/// {@endtemplate}
class CoffeeUrl extends Equatable {
  /// {@macro coffee_url}
  const CoffeeUrl({required this.url});

  /// Factory which converts a [Map<String, Object?>] into a [CoffeeUrl].
  factory CoffeeUrl.fromJson(Map<String, Object?> json) =>
      _$CoffeeUrlFromJson(json);

  /// Converts the [CoffeeUrl] to [Map<String, Object?>].
  Map<String, Object?> toJson() => _$CoffeeUrlToJson(this);

  /// Image URL for [CoffeeUrl]
  @JsonKey(name: 'file')
  final String url;

  @override
  List<Object?> get props => [url];
}
