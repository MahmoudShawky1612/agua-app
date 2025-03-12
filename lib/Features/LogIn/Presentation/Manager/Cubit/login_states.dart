import '../../../Data/Model/user_model.dart';

abstract class LogInStates {}
class InitialLogInState extends LogInStates{}

class LoadingLogInState extends LogInStates{}

class SuccessLogInState extends LogInStates{
  final UserModel  user;
  SuccessLogInState(this.user);
}
class ErrorLogInState extends LogInStates{
  String message;

  ErrorLogInState(this.message);
}
