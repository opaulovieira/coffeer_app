import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorites_action.dart';
part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required CoffeeRepository coffeeRepository})
      : _coffeeRepository = coffeeRepository,
        super(const Loading()) {
    on<RequestUnfavorite>(_onRequestUnfavorite());
    on<CancelUnfavorite>(_onCancelUnfavorite());
    on<RequestImages>(_onRequestImages());
    on<Unfavorite>(_onUnfavorite());
  }

  final CoffeeRepository _coffeeRepository;

  EventHandler<RequestUnfavorite, FavoritesState> _onRequestUnfavorite() {
    return (event, emit) {
      final state = this.state;
      if (state is Idle) {
        emit(
          state.copyWith(action: RequestUnfavoriteConfirmation(key: event.id)),
        );
      }
    };
  }

  EventHandler<CancelUnfavorite, FavoritesState> _onCancelUnfavorite() {
    return (event, emit) {
      final state = this.state;
      if (state is Idle) {
        emit(Idle(coffeeList: state.coffeeList));
      }
    };
  }

  EventHandler<RequestImages, FavoritesState> _onRequestImages() {
    return (event, emit) async {
      final coffees = await _coffeeRepository.getFavoriteCoffees();

      if (coffees.isEmpty) {
        emit(const Empty());
      } else {
        emit(Idle(coffeeList: coffees));
      }
    };
  }

  EventHandler<Unfavorite, FavoritesState> _onUnfavorite() {
    return (event, emit) async {
      final state = this.state;
      if (state is Idle) {
        await _coffeeRepository.unfavoriteCoffee(event.id);

        final newList = state.coffeeList
            .where((favoriteCoffee) => favoriteCoffee.id != event.id)
            .toList();

        if (newList.isEmpty) {
          emit(const Empty());
        } else {
          emit(Idle(coffeeList: newList));
        }
      }
    };
  }
}
