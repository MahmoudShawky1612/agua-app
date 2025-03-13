
import '../../../../../LogIn/Data/Model/user_model.dart';

abstract class UserStates {}

class InitialUserState extends UserStates {}

class LoadingUserState extends UserStates {}

class SuccessUserState extends UserStates {
  final UserModel user;
  SuccessUserState(this.user);
}

class ErrorUserState extends UserStates {
  final String message;
  ErrorUserState(this.message);
}
