part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ListOfItems> lists;
  final String? message;

  const HomeLoaded({
    required this.lists,
    this.message,
  });

  @override
  List<Object> get props => [lists];
}
