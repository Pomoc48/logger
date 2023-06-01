part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ListOfItems> lists;

  const HomeLoaded({
    required this.lists,
  });

  @override
  List<Object> get props => [lists];
}

class HomeMessage extends HomeState {
  final String message;

  const HomeMessage(this.message);

  @override
  List<Object> get props => [message];
}
