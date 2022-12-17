import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:log_app/models/table.dart';
import 'package:log_app/pages/home/bloc/functions.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      List? serverConfig = GetStorage().read('serverConfig');

      if (serverConfig == null) {
        emit(HomeServerSetup());
      } else {
        try {
          emit(HomeLoaded(await getTables(serverConfig)));
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
        List serverConfig = GetStorage().read('serverConfig');
        
        await addTable(event.newTable, serverConfig);
        emit(HomeLoaded(await getTables(serverConfig)));
      } catch (e) {
        emit(HomeError());
      }
    });

    on<RemoveFromHome>((event, emit) async {
      try {
        List serverConfig = GetStorage().read('serverConfig');

        await removeTable(event.table.name, serverConfig);
        emit(HomeLoaded(await getTables(serverConfig)));
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
