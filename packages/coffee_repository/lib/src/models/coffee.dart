import 'dart:typed_data';

/// {@template coffee}
/// A Coffee object that holds both image and favorite information
/// {@endtemplate}
class Coffee {
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
}
