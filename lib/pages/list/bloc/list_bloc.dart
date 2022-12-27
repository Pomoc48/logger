import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/row.dart';
import 'package:logger_app/models/table.dart';
import 'package:logger_app/pages/list/bloc/functions.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<LoadList>((event, emit) async {
      emit(ListInitial());

      try {
        Map map = await getTableRows(
          table: event.table.name,
          token: event.token,
        );

        var rows = List<RowItem>.from(map["data"]);

        emit(ListLoaded(
          rowList: rows,
          title: event.table.name,
          chartData: getChartData(rows),
          token: map["token"],
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<InsertList>((event, emit) async {
      try {
        Map response = await addRow(
          table: event.name,
          timestamp: event.timestamp,
          token: event.token,
        );

        if (response["success"]) {
          Map map = await getTableRows(
            table: event.name,
            token: response["token"],
          );

          var rows = List<RowItem>.from(map["data"]);

          emit(ListLoaded(
            rowList: rows,
            title: event.name,
            chartData: getChartData(rows),
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
        Map response = await removeRow(
          table: event.title,
          rowId: event.row.id,
          token: event.token,
        );

        if (response["success"]) {
          Map map = await getTableRows(
            table: event.title,
            token: response["token"],
          );

          var rows = List<RowItem>.from(map["data"]);

          emit(ListLoaded(
            rowList: rows,
            title: event.title,
            chartData: getChartData(rows),
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
        rowList: event.rowList,
        title: event.title,
        chartData: event.chartData,
        token: event.token,
      ));
    });

    on<ReportListError>((event, emit) {
      emit(ListError());
    });
  }
}
