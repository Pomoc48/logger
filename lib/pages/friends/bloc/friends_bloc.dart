import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/friend.dart';
import 'package:logger_app/pages/friends/bloc/functions.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<LoadFriends>((event, emit) async {
      try {
        Map map = await getFriends(
          token: event.token,
        );

        var items = List<Friend>.from(map["data"]);

        emit(FriendsLoaded(
          friends: items,
          token: map["token"],
        ));
      } catch (e) {
        emit(FriendsError());
      }
    });
    on<UpdateFriends>((event, emit) {
      emit(FriendsLoaded(
        friends: event.friends,
        token: event.token,
      ));
    });
  }
}
