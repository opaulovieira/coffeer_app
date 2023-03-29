import 'package:coffee_repository/coffee_repository.dart';

abstract class CarouselState {}

class Loading implements CarouselState {
  const Loading();
}

class Idle implements CarouselState {
  const Idle(this.coffee);

  final Coffee? coffee;
}
