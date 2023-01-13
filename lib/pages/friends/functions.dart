import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/models/friend.dart';
import 'package:logger_app/pages/friends/bloc/friends_bloc.dart';
import 'package:logger_app/pages/friends/bloc/functions.dart';

Future<void> refresh({
  required BuildContext context,
  required FriendsLoaded state,
}) async {
  try {
    Map map = await getFriends(token: state.token);
    List<Friend> list = List<Friend>.from(map["data"]);

    // ignore: use_build_context_synchronously
    BlocProvider.of<FriendsBloc>(context).add(UpdateFriends(
      friends: list,
      token: map["token"],
    ));
  } catch (e) {
    BlocProvider.of<FriendsBloc>(context).add(ReportFriendsError());
  }
}
