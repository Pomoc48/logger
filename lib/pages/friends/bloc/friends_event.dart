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

class ReportFriendsError extends FriendsEvent {}
