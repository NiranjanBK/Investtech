part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class GetHomePageEvent extends HomeEvent {
  final String? marketCode;

  GetHomePageEvent(this.marketCode);

  @override
  List<Object?> get props => [marketCode];
}

