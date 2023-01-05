part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeError extends HomeState {
  final String token;

  const HomeError({required this.token});

  @override
  List<Object> get props => [token];
}

class HomeLoaded extends HomeState {
  final String token;
  final List<ListOfItems> lists;
  final SortingType sort;
  final String username;
  final String profileUrl;

  const HomeLoaded({
    required this.lists,
    required this.token,
    required this.sort,
    required this.username,
    required this.profileUrl,
  });

  @override
  List<Object> get props => [lists, token, sort, username, profileUrl];
}

class HomeMessage extends HomeState {
  final String message;
  final String? link;

  const HomeMessage(this.message, [this.link]);

  @override
  List<Object> get props => [message];
}

class HomeLoginRequired extends HomeState {}

class RegisterResults extends HomeState {
  final bool registered;
  final String message;

  const RegisterResults({required this.registered, required this.message});

  @override
  List<Object> get props => [registered, message];
}
