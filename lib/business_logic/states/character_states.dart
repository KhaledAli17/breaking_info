
import 'package:breaking_api/data/model/character_model.dart';
import 'package:breaking_api/data/model/quote_model.dart';

abstract class CharactersState{}

class CharacterInitialState extends CharactersState{}

class CharacterSuccessfullyLoaded extends CharactersState{
  final List<CharacterModel> characters;

  CharacterSuccessfullyLoaded(this.characters);
}

class QuoteSuccessfullyLoaded extends CharactersState{
    final List<Quote> quotes;

    QuoteSuccessfullyLoaded(this.quotes);
}