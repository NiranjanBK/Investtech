part of 'home_bloc.dart';

abstract class HomeState extends Equatable {}

class HttpLoadingState extends HomeState {
  @override
  List<Object> get props => [];
}

class HttpInitialState extends HomeState {
  @override
  List<Object> get props => [];
}

class ErrorState extends HomeState {
  final String errorBody;

  ErrorState(this.errorBody);
  @override
  List<Object> get props => [errorBody];
}

class HomeLoadedState extends HomeState {
  final Home home;

  HomeLoadedState(this.home);

  @override
  List<Object?> get props => [home];
}
