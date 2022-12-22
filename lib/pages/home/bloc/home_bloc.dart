import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/table.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      try {
        emit(HomeLoaded(
          tables: await getTables(event.token),
          token: event.token,
        ));
      } catch (e) {
        emit(HomeError(token: event.token));
      }
    });

    on<UpdateHome>((event, emit) {
      emit(HomeLoaded(tables: event.tables, token: event.token));
    });

    on<InsertHome>((event, emit) async {
      try {
        await addTable(event.newTable);
        emit(HomeLoaded(
          tables: await getTables(event.token),
          token: event.token,
        ));
      } catch (e) {
        emit(HomeError(token: event.token));
      }
    });

    on<RemoveFromHome>((event, emit) async {
      try {
        await removeTable(event.table.name);
        emit(HomeLoaded(
          tables: await getTables(event.token),
          token: event.token,
        ));
      } catch (e) {
        emit(HomeError(token: event.token));
      }
    });

    on<ReportHomeError>((event, emit) {
      emit(HomeError(token: event.token));
    });
  }
}
