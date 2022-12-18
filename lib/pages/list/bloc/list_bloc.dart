import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:log_app/models/row.dart';
import 'package:log_app/models/table.dart';
import 'package:log_app/pages/list/bloc/functions.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(const ListInitial("")) {
    on<LoadList>((event, emit) async {
      emit(ListInitial(event.table.name));

      try {
        List serverConfig = GetStorage().read('serverConfig');
        List<RowItem> rowList = await getTableRows(serverConfig, event.table.name);
        
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
        List serverConfig = GetStorage().read('serverConfig');
        await addRow(event.name, event.timestamp, serverConfig);

        List<RowItem> rowList = await getTableRows(serverConfig, event.name);

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
        List serverConfig = GetStorage().read('serverConfig');
        await removeRow(event.title, event.row.id, serverConfig);

        List<RowItem> rowList = await getTableRows(serverConfig, event.title);

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
