import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      try {
        Response response = await get(
          Uri.parse("https://lukawski.xyz/logs/tables/"),
        );

        dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));

        if (decoded == null) {
          emit(const HomeLoaded([]));
          return;
        }

        List<String> stringList = decoded.cast<String>();
        emit(HomeLoaded(stringList));
      }

      catch (e) {
        emit(HomeError());
      }
    });
  }
}
