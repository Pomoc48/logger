import 'package:equatable/equatable.dart';

enum FriendStatus { pending, accepted, action }

class Friend extends Equatable {
  final int requestId;
  final int userId;
  final FriendStatus status;
  final DateTime timestamp;
  final String username;
  final String profileUrl;

  const Friend({
    required this.requestId,
    required this.userId,
    required this.status,
    required this.timestamp,
    required this.username,
    required this.profileUrl,
  });

  factory Friend.fromMap(dynamic map) {
    FriendStatus getStatus(int value) {
      if (value == 0) return FriendStatus.pending;
      if (value == 1) return FriendStatus.accepted;
      return FriendStatus.action;
    }

    return Friend(
      requestId: map["id"],
      userId: map["user_id"],
      status: getStatus(map["status"]),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["timestamp"] * 1000),
      username: map["username"],
      profileUrl: map["profile_url"],
    );
  }

  @override
  List<Object> get props =>
      [requestId, status, timestamp, username, profileUrl];
}
