import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/carousel/bloc/carousel_event.dart';
import 'package:coffeer_app/carousel/bloc/carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  CarouselBloc({
    required this.url,
    required CoffeeRepository coffeeRepository,
  })  : _coffeeRepository = coffeeRepository,
        super(const Loading()) {
    on<ImageBytesLoad>(_onImageBytesLoad());
    on<ToggleFavoriteStateCoffee>(_onToggleFavoriteStateCoffee());
  }

  final String url;
  final CoffeeRepository _coffeeRepository;

  EventHandler<ImageBytesLoad, CarouselState> _onImageBytesLoad() {
    return (event, emit) async {
      final bytes = event.bytes;

      if (bytes != null) {
        final coffee = Coffee(bytes: bytes, url: url);

        final isFavorite = await _coffeeRepository.isCoffeeFavorite(coffee);

        emit(Idle(coffee.copyWith(isFavorite: isFavorite)));
      }
    };
  }

  EventHandler<ToggleFavoriteStateCoffee, CarouselState>
      _onToggleFavoriteStateCoffee() {
    return (event, emit) async {
      final state = this.state;

      if (state is Idle) {
        final coffee = state.coffee;

        if (coffee != null) {
          final isFavorite = coffee.isFavorite;

          if (isFavorite) {
            await _coffeeRepository.unfavoriteCoffee(coffee);
          } else {
            await _coffeeRepository.favoriteCoffee(coffee);
          }

          emit(Idle(coffee.copyWith(isFavorite: !isFavorite)));
        }
      }
    };
  }
}
