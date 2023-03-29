part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class RequestImages implements HomeEvent {
  const RequestImages();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class TryAgain implements HomeEvent {
  const TryAgain();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
