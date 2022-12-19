import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/models/row.dart';
import 'package:logger_app/models/table.dart';
import 'package:logger_app/pages/list/bloc/functions.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(const ListInitial("")) {
    on<LoadList>((event, emit) async {
      emit(ListInitial(event.table.name));

      try {
        List<RowItem> rowList = await getTableRows(event.table.name);
        
        emit(ListLoaded(
          rowList: rowList,
          title: event.table.name,
          chartData: getChartData(rowList),
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<InsertList>((event, emit) async {
      try {
        await addRow(event.name, event.timestamp);
        List<RowItem> rowList = await getTableRows(event.name);

        emit(ListLoaded(
          rowList: rowList,
          title: event.name,
          chartData: getChartData(rowList),
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<RemoveFromList>((event, emit) async {
      try {
        await removeRow(event.title, event.row.id);
        List<RowItem> rowList = await getTableRows(event.title);

        emit(ListLoaded(
          rowList: rowList,
          title: event.title,
          chartData: getChartData(rowList),
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
      ));
    });

    on<ReportListError>((event, emit) {
      emit(ListError());
    });
  }
}
