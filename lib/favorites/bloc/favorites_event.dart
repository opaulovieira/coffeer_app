part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class Unfavorite extends Equatable implements FavoritesEvent {
  const Unfavorite({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class RequestImages extends Equatable implements FavoritesEvent {
  const RequestImages();

  @override
  List<Object?> get props => [];
}

class RequestUnfavorite extends Equatable implements FavoritesEvent {
  const RequestUnfavorite({required this.id});

  final String id;

  @override
  List<Object?> get props => [];
}

class CancelUnfavorite extends Equatable implements FavoritesEvent {
  const CancelUnfavorite();

  @override
  List<Object?> get props => [];
}
