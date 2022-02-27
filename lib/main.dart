
import 'package:breaking_api/ui/screens/home.dart';
import 'package:flutter/material.dart';


void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp( Breaking());
 // ApiCall().getCharactersData();

}

class Breaking extends StatelessWidget {
   Breaking({Key? key , }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
