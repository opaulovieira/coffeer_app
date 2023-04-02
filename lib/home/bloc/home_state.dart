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

enum ErrorDetail {
  unexpected('Ops, sorry... \nSomething went wrong!'),
  data(
    'Hey, it is not me, it is y-... Ok, the error is on me. '
    'There is no available data',
  ),
  internet('Well... It seems the internet connection is not working.');

  const ErrorDetail(this.message);

  final String message;
}

class Error extends Equatable implements HomeState {
  const Error({required this.detail});

  final ErrorDetail detail;

  @override
  List<Object?> get props => [detail];

  @override
  bool? get stringify => false;

  @override
  String toString() {
    return 'Error(error: $detail)';
  }
}
