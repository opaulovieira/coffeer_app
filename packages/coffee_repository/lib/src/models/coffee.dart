import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// {@template coffee}
/// A Coffee object that holds both image and favorite information
/// {@endtemplate}
class Coffee extends Equatable {
  /// {@macro coffee}
  const Coffee({
    required this.bytes,
    this.url,
    this.isFavorite = false,
  });

  /// Verifies if [Coffee] is saved locally
  final bool isFavorite;

  /// [Coffee] image in byte codes
  final Uint8List bytes;

  /// Url used to request the [Coffee] image
  final String? url;

  @override
  List<Object?> get props => [isFavorite, bytes];
}
