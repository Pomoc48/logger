import 'package:equatable/equatable.dart';

class Friend extends Equatable {
  final int requestId;
  final bool accepted;
  final DateTime timestamp;
  final int friendId;
  final String username;
  final String profileUrl;

  const Friend({
    required this.requestId,
    required this.accepted,
    required this.timestamp,
    required this.friendId,
    required this.username,
    required this.profileUrl,
  });

  factory Friend.fromMap(dynamic map) {
    return Friend(
      requestId: map["id"],
      accepted: map["accepted"] == 1 ? true : false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["timestamp"] * 1000),
      friendId: map["friend_id"],
      username: map["username"],
      profileUrl: map["profile_url"],
    );
  }

  @override
  List<Object> get props =>
      [requestId, accepted, timestamp, friendId, username, profileUrl];
}
