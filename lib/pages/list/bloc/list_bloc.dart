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
  }
}
