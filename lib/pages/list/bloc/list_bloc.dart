import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/item.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/list/bloc/functions.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<LoadList>((event, emit) async {
      emit(ListInitial());

      try {
        Map map = await getItems(
          listId: event.list.id,
          token: event.token,
        );

        var items = List<ListItem>.from(map["data"]);

        emit(ListLoaded(
          itemList: items,
          list: event.list,
          chartData: getChartData(items),
          token: map["token"],
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<InsertList>((event, emit) async {
      try {
        Map response = await addItem(
          listId: event.list.id,
          timestamp: event.timestamp,
          token: event.token,
        );

        if (response["success"]) {
          Map map = await getItems(
            listId: event.list.id,
            token: response["token"],
          );

          var items = List<ListItem>.from(map["data"]);

          emit(ListLoaded(
            itemList: items,
            list: event.list,
            chartData: getChartData(items),
            token: map["token"],
          ));
        } else {
          emit(ListMessage(response["message"]));
        }
      } catch (e) {
        emit(ListError());
      }
    });

    on<RemoveFromList>((event, emit) async {
      try {
        Map response = await removeItem(
          itemId: event.item.id,
          token: event.token,
        );

        if (response["success"]) {
          Map map = await getItems(
            listId: event.list.id,
            token: response["token"],
          );

          var items = List<ListItem>.from(map["data"]);

          emit(ListLoaded(
            itemList: items,
            list: event.list,
            chartData: getChartData(items),
            token: map["token"],
          ));
        } else {
          emit(ListMessage(response["message"]));
        }
      } catch (e) {
        emit(ListError());
      }
    });

    on<UpdateList>((event, emit) async {
      emit(ListLoaded(
        itemList: event.itemList,
        list: event.list,
        chartData: event.chartData,
        token: event.token,
      ));
    });

    on<ReportListError>((event, emit) {
      emit(ListError());
    });
  }
}
