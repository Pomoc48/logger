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
        List<RowItem> rowList = await getTableRows(table: event.table.name, token: event.token);

        emit(ListLoaded(
          rowList: rowList,
          title: event.table.name,
          chartData: getChartData(rowList),
          token: event.token,
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<InsertList>((event, emit) async {
      try {
        await addRow(table: event.name, timestamp: event.timestamp, token: event.token);
        List<RowItem> rowList = await getTableRows(table: event.name, token: event.token);

        emit(ListLoaded(
          rowList: rowList,
          title: event.name,
          chartData: getChartData(rowList),
          token: event.token,
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<RemoveFromList>((event, emit) async {
      try {
        await removeRow(table: event.title, rowId: event.row.id, token: event.token);
        List<RowItem> rowList = await getTableRows(table: event.title, token: event.token);

        emit(ListLoaded(
          rowList: rowList,
          title: event.title,
          chartData: getChartData(rowList),
          token: event.token,
        ));
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
