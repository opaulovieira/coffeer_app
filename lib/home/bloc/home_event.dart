part of 'home_bloc.dart';

abstract class HomeEvent {}

class RequestImages extends Equatable implements HomeEvent {
  const RequestImages();

  @override
  List<Object?> get props => [];
}

class TryAgain extends Equatable implements HomeEvent {
  const TryAgain();

  @override
  List<Object?> get props => [];
}

class Favorite extends Equatable implements HomeEvent {
  const Favorite({required this.coffee});

  final Coffee coffee;

  @override
  List<Object?> get props => [coffee];
}

class Unfavorite extends Equatable implements HomeEvent {
  const Unfavorite({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class UpdateFavoriteState extends Equatable implements HomeEvent {
  const UpdateFavoriteState();

  @override
  List<Object?> get props => [];
}
