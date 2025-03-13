import 'package:aguaapplication/Features/Home/Data/Service/api_handler.dart';
import 'package:aguaapplication/Features/Home/Presentation/Presentation/Manager/Cubit/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDrinkCubit extends Cubit<AddDrinkStates>{
  final AddDrinkService addDrinkService;
  AddDrinkCubit(this.addDrinkService):super(InitialAddDrinkState());

  Future<void> addDrink(int userId)async{
    try{
      emit(LoadingAddDrinkState());
      final drink = await addDrinkService.addDrink(userId);
      emit(SuccessAddDrinkState(drink));
    }catch(e){
      print(e);
      emit(ErrorAddDrinkState("Something went wrong!, $e"));
    }
  }
}