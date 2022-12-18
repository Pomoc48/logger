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
        
        emit(ListLoaded(
          rowList: await getTableRows(serverConfig, event.table.name),
          title: event.table.name,
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<InsertList>((event, emit) async {
      try {
        List serverConfig = GetStorage().read('serverConfig');
        await addRow(event.name, event.timestamp, serverConfig);

        emit(ListLoaded(
          rowList: await getTableRows(serverConfig, event.name),
          title: event.name,
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<RemoveFromList>((event, emit) async {
      try {
        List serverConfig = GetStorage().read('serverConfig');
        await removeRow(event.title, event.row.id, serverConfig);

        emit(ListLoaded(
          rowList: await getTableRows(serverConfig, event.title),
          title: event.title,
        ));
      } catch (e) {
        emit(ListError());
      }
    });

    on<UpdateList>((event, emit) async {
      emit(ListLoaded(
        rowList: event.rowList,
        title: event.title,
      ));
    });

    on<ReportListError>((event, emit) {
      emit(ListError());
    });
  }
}
