import 'package:aguaapplication/Features/History/Data/Model/drink_model.dart';

abstract class DrinkStates {}

class InitialDrinkState extends DrinkStates {}

class LoadingDrinkState extends DrinkStates {}

class SuccessDrinkState extends DrinkStates {
  final List<DrinksModel> drinks;
  SuccessDrinkState(this.drinks);
}

class ErrorDrinkState extends DrinkStates {
  final String message;
  ErrorDrinkState(this.message);
}
