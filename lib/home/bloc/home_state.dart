part of 'home_bloc.dart';

abstract class HomeState extends Equatable {}

class Loading implements HomeState {
  const Loading();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class Success implements HomeState {
  const Success({
    required this.coffeeUrlList,
    this.loadedCoffeeList = const <Coffee>[],
  });

  final List<String> coffeeUrlList;
  final List<Coffee> loadedCoffeeList;

  @override
  List<Object?> get props => [coffeeUrlList, loadedCoffeeList];

  @override
  bool? get stringify => false;

  @override
  String toString() {
    return 'Success(loadedCoffeeList: $loadedCoffeeList,'
        ' coffeeUrlList: $coffeeUrlList)';
  }
}

class Error implements HomeState {
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
