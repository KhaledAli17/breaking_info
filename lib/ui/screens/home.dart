import 'package:breaking_api/business_logic/cubit/character_cubit.dart';
import 'package:breaking_api/business_logic/states/character_states.dart';
import 'package:breaking_api/constants/constants.dart';
import 'package:breaking_api/data/model/character_model.dart';
import 'package:breaking_api/data/repository/character_repo.dart';
import 'package:breaking_api/data/service/api_call.dart';
import 'package:breaking_api/ui/screens/character_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CharacterModel> characterSearch;
  late List<CharacterModel> allCharacters;
  bool isSearch = false;
  var searchController = TextEditingController();

  Widget buildSearchText() => TextFormField(
        controller: searchController,
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: 'find a character...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 18),
        onChanged: (searchCharacter) {
          searchedList(searchCharacter);
        },
      );
  List<Widget> buildAppBarAction() {
    if (isSearch) {
      return [
        IconButton(
          onPressed: () {
            setState(() {
              clearSearch;
              Navigator.pop(context);
            });
          },
          icon: const Icon(Icons.clear, color: Colors.white),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: startSearch,
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // var characterRepo = CharactersRepository(ApiCall());
    // var cubit = CharactersCubit(characterRepo);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: isSearch ? buildSearchText() : const Text('Characters'),
        actions: buildAppBarAction(),
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
      ),
      body: OfflineBuilder(connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          return BlocProvider(
            create: (context) => cubit..getAllCharacters(),
            child: BlocConsumer<CharactersCubit, CharactersState>(
              listener: (context, state) {},
              builder: (context, state) {
                allCharacters = CharactersCubit.get(context).getAllCharacters();
                return Conditional.single(
                  context: context,
                  conditionBuilder: (BuildContext context) =>
                      state is CharacterSuccessfullyLoaded,
                  widgetBuilder: (BuildContext context) => GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchController.text.isEmpty
                          ? allCharacters.length
                          : characterSearch.length,
                      itemBuilder: (context, index) {
                        return buildItemComponent(
                            searchController.text.isEmpty
                                ? allCharacters[index]
                                : characterSearch[index],
                            context);
                      }),
                  fallbackBuilder: (BuildContext context) => const Center(
                      child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  )),
                );
              },
            ),
          );
        } else {
          return bulidNoInternet();
        }
      },
        child : const Center(
            child: CircularProgressIndicator(
              color: Colors.redAccent,
            )),),
    );
  }

  void searchedList(String character) {
    characterSearch = allCharacters
        .where((element) => element.name!.toLowerCase().startsWith(character))
        .toList();
    setState(() {});
  }

  void startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearch));
    setState(() {
      isSearch = true;
    });
  }

  void stopSearch() {
    clearSearch();
    setState(() {
      isSearch = false;
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
    });
  }
}



Widget buildItemComponent(CharacterModel character, context) => Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CharacterDetails(charcter: character)));
        },
        child: GridTile(
          child: Hero(
            tag: character.charId as int,
            child: Container(
                padding: const EdgeInsets.all(8),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height * 0.30,
                  imageUrl: '${character.img}',
                  placeholder: (context, url) => const Center(
                      child: SizedBox(
                    width: 100,
                    height: 250,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      strokeWidth: 1,
                      colors: [Colors.redAccent, Colors.black, Colors.white],
                    ),
                  )),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage('assets/imgs/step.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          footer: Container(
            //width: double.infinity,
            color: Colors.black54,
            margin: const EdgeInsets.all(8),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            alignment: AlignmentDirectional.bottomCenter,
            child: Text(
              '${character.name}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
Widget bulidNoInternet() => Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 30,
            ),
            Image(image: AssetImage('assets/imgs/warning.png')),
            Text(
              'Check your Internet',
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
              ),
            ),

          ],
        ),
      ),
    );
