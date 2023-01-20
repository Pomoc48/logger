part of 'friends_home_bloc.dart';

abstract class FriendsHomeState extends Equatable {
  const FriendsHomeState();

  @override
  List<Object> get props => [];
}

class FriendsHomeInitial extends FriendsHomeState {}

class FriendsHomeError extends FriendsHomeState {}

class FriendsHomeLoaded extends FriendsHomeState {
  final String token;
  final List<ListOfItems> lists;
  final Friend friend;

  const FriendsHomeLoaded({
    required this.lists,
    required this.token,
    required this.friend,
  });

  @override
  List<Object> get props => [lists, token, friend];
}
