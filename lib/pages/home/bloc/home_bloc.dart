import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_app/models/table.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      if (GetStorage().read('serverConfig') == null) {
        emit(HomeServerSetup());
      } else {
        try {
          emit(HomeLoaded(await getTables()));
        } catch (e) {
          emit(HomeError());
        }
      }
    });

    on<UpdateHome>((event, emit) {
      emit(HomeLoaded(event.tables));
    });

    on<InsertHome>((event, emit) async {
      try {
        await addTable(event.newTable);
        emit(HomeLoaded(await getTables()));
      } catch (e) {
        emit(HomeError());
      }
    });

    on<RemoveFromHome>((event, emit) async {
      try {
        await removeTable(event.table.name);
        emit(HomeLoaded(await getTables()));
      } catch (e) {
        emit(HomeError());
      }
    });

    on<ReportHomeError>((event, emit) {
      emit(HomeError());
    });

    on<ReportServerUpdate>((event, emit) {
      emit(HomeServerSetup());
    });
  }
}
