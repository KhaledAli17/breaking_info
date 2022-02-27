import 'package:bloc/bloc.dart';
import 'package:breaking_api/business_logic/states/character_states.dart';
import 'package:breaking_api/data/model/character_model.dart';
import 'package:breaking_api/data/repository/character_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this.charactersRepository) : super(CharacterInitialState());
  static CharactersCubit get(context) => BlocProvider.of(context);
  final CharactersRepository charactersRepository;

  List<CharacterModel> character = [];

  List<CharacterModel> getAllCharacters() {
    charactersRepository.getCharactersData().then((character) {
      emit(CharacterSuccessfullyLoaded(character));
      this.character = character;
    });
    return character;
  }

 void getQuote(String name) {
    try{
       charactersRepository.getCharactersQuote(name).then((quote) {
   emit(QuoteSuccessfullyLoaded(quote));
   });
    }catch(e){
      print(e.toString());
    }


  }
}
