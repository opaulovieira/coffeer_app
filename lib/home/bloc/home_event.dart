part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class OnRequestImages implements HomeEvent {
  const OnRequestImages({this.shouldAccumulate = false});

  final bool shouldAccumulate;

  @override
  List<Object?> get props => [shouldAccumulate];

  @override
  bool? get stringify => true;
}

class TryAgain implements HomeEvent {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
