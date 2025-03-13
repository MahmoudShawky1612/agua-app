import 'package:aguaapplication/Features/Home/Data/Model/drink_model.dart';

abstract class AddDrinkStates {}
class InitialAddDrinkState extends AddDrinkStates{}

class LoadingAddDrinkState extends AddDrinkStates{}

class SuccessAddDrinkState extends AddDrinkStates{
  final DrankModel  drink;
  SuccessAddDrinkState(this.drink);
}
class ErrorAddDrinkState extends AddDrinkStates{
  String message;

  ErrorAddDrinkState(this.message);
}