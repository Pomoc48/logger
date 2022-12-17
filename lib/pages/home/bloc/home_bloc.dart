import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:log_app/pages/home/bloc/functions.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      try {
        emit(HomeLoaded(await getTables()));
      } catch (e) {
        emit(HomeError());
      }
    });

    on<UpdateHome>((event, emit) {
      emit(HomeLoaded(event.tableList));
    });
  }
}
