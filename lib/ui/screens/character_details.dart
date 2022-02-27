import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_api/business_logic/cubit/character_cubit.dart';
import 'package:breaking_api/business_logic/states/character_states.dart';
import 'package:breaking_api/constants/constants.dart';
import 'package:breaking_api/data/model/character_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CharacterDetails extends StatelessWidget {
  final CharacterModel charcter;
  const CharacterDetails({Key? key, required this.charcter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: BlocProvider(
        create: (context) => cubit..getQuote('${charcter.name}'),
        child: CustomScrollView(
          slivers: [
        buildSliverBar(),
        SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCharacterInfo('Job : ', charcter.occupation!.join(' / ')),
                      buildDivider(315),
                      buildCharacterInfo('Appeared in  : ', '${charcter.category}'),
                      buildDivider(250),
                      buildCharacterInfo('Seasons : ', charcter.appearance!.join( ' / ')),
                      buildDivider(280),
                      buildCharacterInfo('Status : ', '${charcter.status}'),
                      buildDivider(300),
                      charcter.betterCallSaulAppearance!.isEmpty
                          ? Container()
                          : buildCharacterInfo('Better Call Saul Appearance : ', charcter.betterCallSaulAppearance!.join(' / ')),
                      charcter.betterCallSaulAppearance!.isEmpty
                          ? Container()
                          : buildDivider(125),
                      buildCharacterInfo('Actor/Actress : ', '${charcter.name}'),
                      buildDivider(235),
                      const SizedBox(height: 20,),
                       // BlocConsumer<CharactersCubit , CharactersState>(
                       //   listener: (context , state){},
                       //      builder: (context , state){
                       //        return checkIfQuotesLoaded(state , context);
                       //      }),

                    ],
                  ),
                ),
                const SizedBox(height: 500,)
              ]
            ),
    )
          ],
    ),
      ),
    );
  }

  Widget buildSliverBar() => SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.grey,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${charcter.nickname}',
          style: const TextStyle(color: Colors.white),
        ),
        background: Hero(
          tag: charcter.charId as int,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height * 0.30,
            imageUrl: '${charcter.img}',
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
          ),
        ),
      ));
  Widget buildCharacterInfo(String title , String value) => RichText(
    maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )
          ),

          TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
          ),
        ]

      ));
  Widget buildDivider(double value) => Divider(
    height: 30,
    color: Colors.yellow,
    endIndent: value,
     thickness: 2,

  );
  Widget checkIfQuotesLoaded(CharactersState state , context){
    if(state is QuoteSuccessfullyLoaded){
      return displayQuote(state);
    }else{
      return const Center(child: CircularProgressIndicator(color: Colors.yellow,));
    }
  }

  Widget displayQuote(  state) {
    var quote = state.quotes;
    if(quote.length != 0){
      int randomQuote = Random().nextInt(quote.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
            style:const TextStyle(
              fontSize: 20,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: Colors.yellow,
                offset: Offset(0,0),
              )
            ]),
            child: AnimatedTextKit(
              repeatForever: true,
                animatedTexts: [
                  FlickerAnimatedText(quote[randomQuote].quote)
                ])),
      );
    }else{
      return Container();
    }

  }
}
