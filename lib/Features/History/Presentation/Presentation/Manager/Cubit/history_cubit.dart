import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Data/Service/api_handler.dart';
import 'history_states.dart';

class DrinkCubit extends Cubit<DrinkStates> {
  final HistoryService historyService;

  DrinkCubit(this.historyService) : super(InitialDrinkState());

  Future<void> fetchDrinks(int userId) async {
    try {
      emit(LoadingDrinkState());
      final drinks = await historyService.getDrinks(userId);
      emit(SuccessDrinkState(drinks));
    } catch (e) {
       emit(ErrorDrinkState("Something went wrong! $e"));
    }
  }
}