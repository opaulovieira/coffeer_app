import 'package:equatable/equatable.dart';

/// {@template coffee}
/// A Coffee object that holds both url and favorite information
/// {@endtemplate}
class Coffee extends Equatable {
  /// {@macro coffee}
  const Coffee({
    required this.id,
    required this.url,
    this.isFavorite = false,
  });

  /// The identification for this [Coffee] model
  final String id;

  /// Verifies if [Coffee] is saved locally
  final bool isFavorite;

  /// Url used to request the [Coffee] image
  final String url;

  /// Creates a copy of [Coffee] object
  Coffee copyWith({String? id, bool? isFavorite, String? url}) {
    return Coffee(
      id: id ?? this.id,
      url: url ?? this.url,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [isFavorite, url];
}
