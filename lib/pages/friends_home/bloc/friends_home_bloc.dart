import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/friend.dart';
import 'package:logger_app/models/list.dart';

part 'friends_home_event.dart';
part 'friends_home_state.dart';

class FriendsHomeBloc extends Bloc<FriendsHomeEvent, FriendsHomeState> {
  FriendsHomeBloc() : super(FriendsHomeInitial()) {
    on<LoadFriendsHome>((event, emit) async {
      emit(FriendsHomeInitial());

      try {
        Map map = await getFriendLists(
          friendId: event.friend.userId,
          token: event.token,
        );

        var items = List<ListOfItems>.from(map["data"]);

        emit(FriendsHomeLoaded(
          lists: items,
          friend: event.friend,
          token: map["token"],
        ));
      } catch (e) {
        emit(FriendsHomeError());
      }
    });

    on<UpdateFriendsHome>((event, emit) {
      emit(FriendsHomeLoaded(
        lists: event.lists,
        token: event.token,
        friend: event.friend,
      ));
    });
  }
}

Future<Map> getFriendLists({
  required String token,
  required int friendId,
}) async {
  Response response = await makeRequest(
    url: "https://loggerapp.lukawski.xyz/friend-lists/?friend_id=$friendId",
    headers: {"Token": token},
    type: RequestType.get,
  );

  if (response.statusCode == 403) {
    return await getFriendLists(token: await renewToken(), friendId: friendId);
  }

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
  if (decoded == null) return {"data": [], "token": token};

  List<ListOfItems> lists = [];
  for (Map element in decoded) {
    lists.add(ListOfItems.fromMap(element));
  }

  return {"data": lists, "token": token};
}
