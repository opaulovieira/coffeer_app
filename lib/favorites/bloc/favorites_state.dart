part of 'favorites_bloc.dart';

abstract class FavoritesState {}

class Loading extends Equatable implements FavoritesState {
  const Loading();

  @override
  List<Object?> get props => [];
}

class Idle extends Equatable implements FavoritesState {
  const Idle({
    required this.coffeeList,
    this.action,
  });

  final List<Coffee> coffeeList;
  final FavoritesAction? action;

  Idle copyWith({List<Coffee>? coffeeList, FavoritesAction? action}) {
    return Idle(
      coffeeList: coffeeList ?? this.coffeeList,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [coffeeList, action];
}

class Empty extends Equatable implements FavoritesState {
  const Empty();

  @override
  List<Object?> get props => [];
}
