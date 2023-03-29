import 'dart:typed_data';

abstract class CarouselEvent {}

class ImageBytesLoad implements CarouselEvent {
  const ImageBytesLoad({required this.bytes});

  final Uint8List? bytes;
}

class ToggleFavoriteStateCoffee implements CarouselEvent {
  const ToggleFavoriteStateCoffee();
}
