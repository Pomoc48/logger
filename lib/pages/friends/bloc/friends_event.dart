part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadFriends extends FriendsEvent {
  final String token;

  const LoadFriends({required this.token});

  @override
  List<Object> get props => [token];
}

class UpdateFriends extends FriendsEvent {
  final List<Friend> friends;
  final String token;

  const UpdateFriends({
    required this.friends,
    required this.token,
  });

  @override
  List<Object> get props => [friends, token];
}

class ReportFriendsError extends FriendsEvent {}
