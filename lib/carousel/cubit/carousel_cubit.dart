import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';

class CarouselCubit extends Cubit<bool> {
  CarouselCubit({
    required this.url,
    required CoffeeRepository coffeeRepository,
  })  : _coffeeRepository = coffeeRepository,
        super(false) {
    _onInitialLoad();
  }

  final String url;
  final CoffeeRepository _coffeeRepository;

  Future<void> _onInitialLoad() async {
    final isFavorite = await _coffeeRepository.isCoffeeFavorite(url);

    emit(isFavorite);
  }

  Future<void> favorite(Future<Uint8List?> bytesFuture) async {
    final bytes = await bytesFuture;

    if (bytes != null) {
      final coffee = Coffee(bytes: bytes, url: url, isFavorite: state);

      await _coffeeRepository.favoriteCoffee(coffee);
    }

    emit(true);
  }

  Future<void> unfavorite() async {
    await _coffeeRepository.unfavoriteCoffee(url);

    emit(false);
  }
}
