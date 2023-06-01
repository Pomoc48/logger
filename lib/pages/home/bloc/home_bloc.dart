import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/pages/list/bloc/functions.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<AutoLogin>((event, emit) async {
      Map response = await getToken();

      if (response["success"]) {
        String token = response["token"];
        String username = response["username"];
        String profileUrl = response["profile_url"];

        try {
          Map map = await getLists(token: token);
          List<ListOfItems> list = List<ListOfItems>.from(map["data"]);
          sortList(list);

          emit(HomeLoaded(
            lists: list,
            token: map["token"],
            username: username,
            profileUrl: profileUrl,
          ));

          Map map2 = await checkUpdate();
          if (!map2["success"]) {
            emit(HomeMessage(map2["message"], map2["link"]));
          }
        } catch (e) {
          emit(HomeError(token: token));
        }
      } else {
        emit(HomeLoginRequired());
      }
    });

    on<RequestLogin>((event, emit) async {
      Map response = await manualLoginResult(
        username: event.username,
        password: event.password,
      );

      if (response["success"]) {
        String token = response["token"];
        try {
          Map map = await getLists(token: token);
          List<ListOfItems> list = List<ListOfItems>.from(map["data"]);
          sortList(list);

          emit(HomeLoaded(
            lists: list,
            token: map["token"],
            username: response["username"],
            profileUrl: response["profile_url"],
          ));
        } catch (e) {
          emit(HomeError(token: token));
        }
      } else {
        emit(HomeMessage(response["message"]));
      }
    });

    on<RequestRegister>((event, emit) async {
      Map response = await registerResult(
        username: event.username,
        password: event.password,
      );

      emit(RegisterResults(
        registered: response["success"],
        message: response["message"],
      ));
    });

    on<UpdateHome>((event, emit) {
      emit(HomeLoaded(
        profileUrl: event.profileUrl,
        lists: event.lists,
        token: event.token,
        username: event.username,
      ));
    });

    on<InsertHome>((event, emit) async {
      try {
        Map response = await addList(
          name: event.name,
          token: event.state.token,
        );

        if (response["success"]) {
          Map map = await getLists(token: response["token"]);
          List<ListOfItems> list = List<ListOfItems>.from(map["data"]);
          sortList(list);

          emit(HomeLoaded(
            username: event.state.username,
            profileUrl: event.state.profileUrl,
            lists: list,
            token: map["token"],
          ));
        } else {
          emit(HomeMessage(response["message"]));
        }
      } catch (e) {
        emit(HomeError(token: event.state.token));
      }
    });

    on<QuickInsertHome>((event, emit) async {
      try {
        Map response = await addItem(
          listId: event.list.id,
          timestamp: event.timestamp,
          token: event.state.token,
        );

        if (response["success"]) {
          Map map = await getLists(token: response["token"]);
          List<ListOfItems> list = List<ListOfItems>.from(map["data"]);
          sortList(list);

          emit(HomeLoaded(
            profileUrl: event.state.profileUrl,
            username: event.state.username,
            lists: list,
            token: map["token"],
          ));
        } else {
          emit(HomeMessage(response["message"]));
        }
      } catch (e) {
        emit(HomeError(token: event.state.token));
      }
    });

    on<RemoveFromHome>((event, emit) async {
      try {
        Map response = await removeList(
          id: event.id,
          token: event.state.token,
        );

        if (response["success"]) {
          Map map = await getLists(token: response["token"]);
          List<ListOfItems> list = List<ListOfItems>.from(map["data"]);
          sortList(list);

          emit(HomeLoaded(
            profileUrl: event.state.profileUrl,
            username: event.state.username,
            lists: list,
            token: map["token"],
          ));
        } else {
          emit(HomeMessage(response["message"]));
        }
      } catch (e) {
        emit(HomeError(token: event.state.token));
      }
    });

    on<ReportHomeError>((event, emit) {
      emit(HomeError(token: event.token));
    });

    on<ReportLogout>((event, emit) async {
      await forgetSavedToken();
      emit(HomeLoginRequired());
    });

    on<ChangeSort>((event, emit) {
      List<ListOfItems> list = List<ListOfItems>.from(event.state.lists);
      sortList(list);

      emit(HomeLoaded(
        profileUrl: event.state.profileUrl,
        username: event.state.username,
        lists: list,
        token: event.state.token,
      ));
    });

    on<UpdatePhoto>((event, emit) async {
      try {
        Map response = await updatePhoto(
          url: event.url,
          token: event.state.token,
        );

        if (response["success"]) {
          Map map = await getLists(token: response["token"]);
          List<ListOfItems> list = List<ListOfItems>.from(map["data"]);
          sortList(list);

          emit(HomeLoaded(
            profileUrl: event.url,
            username: event.state.username,
            lists: list,
            token: map["token"],
          ));
        } else {
          emit(HomeMessage(response["message"]));
        }
      } catch (e) {
        emit(HomeError(token: event.state.token));
      }
    });
  }
}
