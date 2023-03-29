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
    on<RequestImages>(_onRequestImages());
  }

  final int initialCoffeeQuantity;
  final CoffeeRepository _coffeeRepository;

  EventHandler<RequestImages, HomeState> _onRequestImages() {
    return (event, emit) async {
      try {
        final coffeeUrlList = await Future.wait<String>(
          List.generate(
            initialCoffeeQuantity,
            (index) => _coffeeRepository.getRandomCoffeeUrl(),
          ),
        );

        final state = this.state;
        if (state is Success && event.shouldAccumulate) {
          emit(
            Success(
              coffeeUrlList: {...coffeeUrlList}.toList(),
              loadedCoffeeList: state.loadedCoffeeList,
            ),
          );
        } else {
          emit(Success(coffeeUrlList: coffeeUrlList));
        }
      } catch (error) {
        // TODO(paulosilva): add log (error, stackTrace)
        emit(Error(error: error));
      }
    };
  }
}
