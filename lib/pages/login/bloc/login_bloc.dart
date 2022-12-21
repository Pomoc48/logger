import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger_app/pages/login/bloc/functions.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {

    on<AutoLogin>((event, emit) async {
      Map response = await autoLoginResult();

      if (response["success"]) {
        emit(LoginAccepted(response["token"]));
      } else {
        emit(LoginRequired());
      }
    });

    on<RequestLogin>((event, emit) async {
      Map response = await manualLoginResult(
        username: event.username,
        password: event.password,
      );

      if (response["success"]) {
        emit(LoginAccepted(response["token"]));
      } else {
        emit(LoginMessage(response["message"]));
      }
    });
  }
}
