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
}
