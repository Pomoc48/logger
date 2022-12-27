import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/table.dart';
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
          emit(HomeLoaded(
            tables: await getTables(token: token),
            token: token,
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
          emit(HomeLoaded(
            tables: await getTables(token: token),
            token: token,
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
      emit(HomeLoaded(tables: event.tables, token: event.token));
    });

    on<InsertHome>((event, emit) async {
      try {
        Map response = await addTable(
          table: event.newTable,
          token: event.token,
        );

        if (response["success"]) {
          emit(HomeLoaded(
            tables: await getTables(token: event.token),
            token: event.token,
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
        Map response = await removeTable(
          table: event.table.name,
          token: event.token,
        );

        if (response["success"]) {
          emit(HomeLoaded(
            tables: await getTables(token: event.token),
            token: event.token,
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
