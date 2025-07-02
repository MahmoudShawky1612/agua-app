import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Service/api_handler.dart';
import 'login_states.dart';

class LogInCubit extends Cubit<LogInStates> {
  final LogInService logInService;

  LogInCubit(this.logInService) : super(InitialLogInState());

  Future<void> login(String username, String gender) async {
    try {
      emit(LoadingLogInState());
      final user = await logInService.logIn(username, gender);

      if (user != null) {
        emit(SuccessLogInState(user));
      } else {
        emit(ErrorLogInState("Login failed: Invalid response"));
      }
    } catch (e) {
      emit(ErrorLogInState("Error logging in: $e"));
    }
  }
}
