import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Data/Service/api_handler.dart';
import '../../../../Data/Service/user_api_handler.dart';
import 'user_states.dart';

class UserCubit extends Cubit<UserStates> {
  final UserService userService;

  UserCubit(this.userService) : super(InitialUserState());

  Future<void> fetchUser(int userId) async {
    try {
      emit(LoadingUserState());
      final user = await  userService.getUser(userId);
      emit(SuccessUserState(user));

    } catch (e) {
      print(e);
      emit(ErrorUserState("Something went wrong! $e"));
    }
  }
}