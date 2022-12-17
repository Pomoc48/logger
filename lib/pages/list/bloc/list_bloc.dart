import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:log_app/models/table.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<LoadList>((event, emit) {
      // TODO: implement event handler
    });
  }
}
