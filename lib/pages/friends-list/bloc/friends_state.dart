part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<Friend> friends;
  final String token;

  const FriendsLoaded({
    required this.friends,
    required this.token,
  });

  @override
  List<Object> get props => [friends, token];
}

class FriendsError extends FriendsState {}

class FriendsMessage extends FriendsState {
  final String message;

  const FriendsMessage(this.message);

  @override
  List<Object> get props => [message];
}
