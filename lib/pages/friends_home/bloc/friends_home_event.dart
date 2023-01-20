part of 'friends_home_bloc.dart';

abstract class FriendsHomeEvent extends Equatable {
  const FriendsHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadFriendsHome extends FriendsHomeEvent {
  final Friend friend;
  final String token;

  const LoadFriendsHome({required this.friend, required this.token});

  @override
  List<Object> get props => [friend, token];
}

class UpdateFriendsHome extends FriendsHomeEvent {
  final String token;
  final List<ListOfItems> lists;
  final Friend friend;

  const UpdateFriendsHome({
    required this.lists,
    required this.token,
    required this.friend,
  });

  @override
  List<Object> get props => [lists, token, friend];
}
