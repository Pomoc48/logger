import 'package:flutter/material.dart';
import 'package:logger_app/models/friend.dart';
import 'package:logger_app/strings.dart';

class FriendTrailing extends StatelessWidget {
  const FriendTrailing({required this.friendStatus, super.key});

  final FriendStatus friendStatus;

  @override
  Widget build(BuildContext context) {
    switch (friendStatus) {
      case FriendStatus.pending:
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            Strings.friendPending,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        );
      case FriendStatus.accepted:
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Opacity(
            opacity: 0.38,
            child: Text(
              Strings.friendAccepted,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        );
      case FriendStatus.action:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
          ],
        );
    }
  }
}
