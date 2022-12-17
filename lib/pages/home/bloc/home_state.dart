part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeError extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> tables;

  const HomeLoaded(this.tables);

  @override
  List<Object> get props => [tables];
}
