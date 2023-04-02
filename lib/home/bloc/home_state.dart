part of 'home_bloc.dart';

abstract class HomeState {}

class Loading extends Equatable implements HomeState {
  const Loading();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class Success extends Equatable implements HomeState {
  const Success({required this.coffeeList});

  final List<Coffee> coffeeList;

  @override
  List<Object?> get props => [coffeeList];

  @override
  bool? get stringify => false;

  @override
  String toString() {
    return 'Success(coffeeUrlList: $coffeeList)';
  }
}

class Error extends Equatable implements HomeState {
  const Error({required this.error});

  final Object? error;

  @override
  List<Object?> get props => [error];

  @override
  bool? get stringify => false;

  @override
  String toString() {
    return 'Error(error: $error)';
  }
}
