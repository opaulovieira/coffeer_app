import 'package:bloc/bloc.dart';
import 'package:coffee_api/coffee_api.dart';
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
    on<RequestImages>(_onRequestImages());
    on<TryAgain>(_onTryAgain());
  }

  final int initialCoffeeQuantity;
  final CoffeeRepository _coffeeRepository;

  EventHandler<RequestImages, HomeState> _onRequestImages() {
    return _fetchImages;
  }

  EventHandler<TryAgain, HomeState> _onTryAgain() {
    return (event, emit) async {
      emit(const Loading());

      await _fetchImages(event, emit);
    };
  }

  Future<void> _fetchImages(HomeEvent event, Emitter<HomeState> emit) async {
    try {
      final coffeeUrlList = await Future.wait<String>(
        List.generate(
          initialCoffeeQuantity,
          (index) => _coffeeRepository.getRandomCoffeeUrl(),
        ),
      );

      emit(
        Success(
          coffeeUrlList: {...coffeeUrlList}.toList(),
        ),
      );
    } catch (error) {
      if (error is FailedRequestException) {
        emit(Error(error: error.error));
      } else {
        emit(Error(error: error));
      }
    }
  }
}
