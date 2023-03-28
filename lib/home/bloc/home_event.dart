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

class OnImageBytesLoad implements HomeEvent {
  const OnImageBytesLoad({required this.url, required this.bytes});

  final String url;
  final Uint8List bytes;

  @override
  List<Object?> get props => [url, bytes];

  @override
  bool? get stringify => true;
}

class OnFavoriteImage implements HomeEvent {
  const OnFavoriteImage();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
