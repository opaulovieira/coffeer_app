import 'package:bloc/bloc.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

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
    on<Favorite>(_onFavorite());
    on<Unfavorite>(_onUnfavorite());
    on<UpdateFavoriteState>(_onUpdateFavoriteState());
  }

  final int initialCoffeeQuantity;
  final CoffeeRepository _coffeeRepository;

  EventHandler<Favorite, HomeState> _onFavorite() {
    return (event, emit) async {
      final state = this.state;

      if (state is Success) {
        await _coffeeRepository.favoriteCoffee(event.coffee);

        emit(
          Success(
            coffeeList: state.coffeeList.map((coffee) {
              if (coffee.id == event.coffee.id) {
                return Coffee(id: coffee.id, url: coffee.url, isFavorite: true);
              } else {
                return coffee;
              }
            }).toList(),
          ),
        );
      }
    };
  }

  EventHandler<Unfavorite, HomeState> _onUnfavorite() {
    return (event, emit) async {
      final state = this.state;

      if (state is Success) {
        await _coffeeRepository.unfavoriteCoffee(event.id);

        emit(
          Success(
            coffeeList: state.coffeeList.map((coffee) {
              if (coffee.id == event.id) {
                return Coffee(id: coffee.id, url: coffee.url);
              } else {
                return coffee;
              }
            }).toList(),
          ),
        );
      }
    };
  }

  EventHandler<RequestImages, HomeState> _onRequestImages() {
    return _fetchImages;
  }

  EventHandler<TryAgain, HomeState> _onTryAgain() {
    return (event, emit) async {
      emit(const Loading());

      await _fetchImages(event, emit);
    };
  }

  EventHandler<UpdateFavoriteState, HomeState> _onUpdateFavoriteState() {
    return (event, emit) async {
      final state = this.state;
      if (state is Success) {
        final coffeeList = <Coffee>[];

        for (final coffee in state.coffeeList) {
          final isFavorite =
              await _coffeeRepository.isCoffeeFavorite(coffee.id);

          coffeeList.add(
            Coffee(
              id: coffee.id,
              url: coffee.url,
              isFavorite: isFavorite,
            ),
          );
        }

        emit(
          Success(coffeeList: coffeeList),
        );
      }
    };
  }

  Future<void> _fetchImages(HomeEvent event, Emitter<HomeState> emit) async {
    try {
      final favoriteCoffeeList = await _coffeeRepository.getFavoriteCoffees();

      final coffeeUrlList = await Future.wait<String>(
        List.generate(
          initialCoffeeQuantity,
          (index) => _coffeeRepository.getRandomCoffeeUrl(),
        ),
      );

      final coffeeList = {...coffeeUrlList}.map((url) {
        final isFavorite =
            favoriteCoffeeList.any((coffee) => coffee.url == url);

        return Coffee(id: const Uuid().v4(), url: url, isFavorite: isFavorite);
      }).toList();

      emit(
        Success(coffeeList: coffeeList),
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
