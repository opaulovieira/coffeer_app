part of 'favorites_bloc.dart';

abstract class FavoritesAction {}

class RequestUnfavoriteConfirmation extends Equatable
    implements FavoritesAction {
  const RequestUnfavoriteConfirmation({required this.key});

  final String key;

  @override
  List<Object?> get props => [key];
}
