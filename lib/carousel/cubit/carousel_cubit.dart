import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';

class CarouselCubit extends Cubit<bool> {
  CarouselCubit({
    required this.url,
    required CoffeeRepository coffeeRepository,
  })  : _coffeeRepository = coffeeRepository,
        super(false);

  final String url;
  final CoffeeRepository _coffeeRepository;

  Future<void> onImageBytesLoad(Uint8List? bytes) async {
    if (bytes != null) {
      final coffee = Coffee(bytes: bytes, url: url);

      final isFavorite = await _coffeeRepository.isCoffeeFavorite(coffee);

      emit(isFavorite);
    }
  }
}
