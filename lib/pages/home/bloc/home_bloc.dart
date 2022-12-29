import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<AutoLogin>((event, emit) async {
      Map response = await autoLoginResult();

      if (response["success"]) {
        String token = response["token"];
        try {
          Map map = await getLists(token: token);

          emit(HomeLoaded(
            lists: List<ListOfItems>.from(map["data"]),
            token: map["token"],
          ));
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

          emit(HomeLoaded(
            lists: List<ListOfItems>.from(map["data"]),
            token: map["token"],
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
      emit(HomeLoaded(lists: event.lists, token: event.token));
    });

    on<InsertHome>((event, emit) async {
      try {
        Map response = await addList(
          name: event.name,
          token: event.token,
        );

        if (response["success"]) {
          Map map = await getLists(token: response["token"]);

          emit(HomeLoaded(
            lists: List<ListOfItems>.from(map["data"]),
            token: map["token"],
          ));
        } else {
          emit(HomeMessage(response["message"]));
        }
      } catch (e) {
        emit(HomeError(token: event.token));
      }
    });

    on<RemoveFromHome>((event, emit) async {
      try {
        Map response = await removeList(
          id: event.id,
          token: event.token,
        );

        if (response["success"]) {
          Map map = await getLists(token: response["token"]);

          emit(HomeLoaded(
            lists: List<ListOfItems>.from(map["data"]),
            token: map["token"],
          ));
        } else {
          emit(HomeMessage(response["message"]));
        }
      } catch (e) {
        emit(HomeError(token: event.token));
      }
    });

    on<ReportHomeError>((event, emit) {
      emit(HomeError(token: event.token));
    });

    on<ReportLogout>((event, emit) async {
      await forgetLoginCredentials();
      emit(HomeLoginRequired());
    });
  }
}
