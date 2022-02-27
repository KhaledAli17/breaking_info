import 'package:breaking_api/data/model/character_model.dart';
import 'package:breaking_api/data/model/quote_model.dart';
import 'package:breaking_api/data/service/api_call.dart';

class CharactersRepository {
    final ApiCall apiCall;


    CharactersRepository(this.apiCall);

  Future<List<CharacterModel>> getCharactersData() async {
    final character = await apiCall.getCharactersData();
    return character
        .map((character) => CharacterModel.fromjson(character as Map<String , dynamic>))
        .toList();
  }

    Future<List<Quote>> getCharactersQuote(String name) async {
      final quote = await apiCall.getQuotes(name);
      return quote
          .map((characterQuote) => Quote.fromjson(characterQuote as Map<String , dynamic>))
          .toList();
    }
}
