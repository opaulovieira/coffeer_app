import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required CoffeeRepository coffeeRepository,
    this.initialCoffeeQuantity = 15,
  })  : _coffeeRepository = coffeeRepository,
        super(const Loading()) {
    on<OnRequestImages>(_onRequestImages());
    on<OnImageBytesLoad>(_onImageBytesLoad());
  }

  final int initialCoffeeQuantity;
  final CoffeeRepository _coffeeRepository;

  EventHandler<OnRequestImages, HomeState> _onRequestImages() {
    return (event, emit) async {
      try {
        final coffeeUrList = await Future.wait<String>(
          List.generate(
            initialCoffeeQuantity,
            (index) => _coffeeRepository.getRandomCoffeeUrl(),
          ),
        );

        final state = this.state;
        if (state is Success && event.shouldAccumulate) {
          emit(
            Success(
              coffeeUrlList: [...state.coffeeUrlList, ...coffeeUrList],
              loadedCoffeeList: state.loadedCoffeeList,
            ),
          );
        } else {
          emit(Success(coffeeUrlList: coffeeUrList));
        }
      } catch (error) {
        // TODO(paulosilva): add log (error, stackTrace)
        emit(Error(error: error));
      }
    };
  }

  EventHandler<OnImageBytesLoad, HomeState> _onImageBytesLoad() {
    return (event, emit) async {
      final state = this.state;
      if (state is Success) {
        final coffee = Coffee(bytes: event.bytes, url: event.url);
        final isFavorite = await _coffeeRepository.isCoffeeFavorite(coffee);

        emit(
          Success(
            coffeeUrlList: state.coffeeUrlList,
            loadedCoffeeList: [
              ...state.loadedCoffeeList,
              coffee.copyWith(isFavorite: isFavorite),
            ],
          ),
        );
      }
    };
  }
}
