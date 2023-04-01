part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class Unfavorite extends Equatable implements FavoritesEvent {
  const Unfavorite({required this.key});

  final String key;

  @override
  List<Object?> get props => [key];
}

class RequestImages extends Equatable implements FavoritesEvent {
  const RequestImages();

  @override
  List<Object?> get props => [];
}

class RequestUnfavorite extends Equatable implements FavoritesEvent {
  const RequestUnfavorite({required this.key});

  final String key;

  @override
  List<Object?> get props => [];
}
