
import 'package:breaking_api/business_logic/cubit/character_cubit.dart';
import 'package:breaking_api/data/repository/character_repo.dart';
import 'package:breaking_api/data/service/api_call.dart';

const baseUrl = 'https://www.breakingbadapi.com/api/';
var characterRepo = CharactersRepository(ApiCall());
var cubit = CharactersCubit(characterRepo);