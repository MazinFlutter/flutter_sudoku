import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animated_button.dart';
import 'app_localizations.dart';

import 'highscores_page.dart';
import 'instructions_page.dart';
import 'numbers_board.dart';
import 'settings_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/numbers_3.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(AppLocalizations.of(context, 'Title'),style: TextStyle(fontSize: 86.0, color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            AnimatedButton(title: AppLocalizations.of(context, 'Continue'), onPressed: (){

            }),
            AnimatedButton(title: AppLocalizations.of(context, 'NewGame'), onPressed: (){
              moveToGame(3);
            }),
            AnimatedButton(title: AppLocalizations.of(context, 'HighScores'), onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HighScoresPage()));
            },),
            AnimatedButton(title: AppLocalizations.of(context, 'Settings'), onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },),
            AnimatedButton(title: AppLocalizations.of(context, 'Instructions'), onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => InstructionsPage()));
            },),
            AnimatedButton(title: AppLocalizations.of(context, 'Exit'), onPressed: (){
              exitApp();
            }),
            Padding(
              padding: EdgeInsets.all(15.0),
            ),
          ],
        ),
      ),
    );
  }

  exitApp(){
    print('Good bye');
    SystemNavigator.pop();
  }

  moveToGame(int selectedLevel){
    Navigator.push(context, MaterialPageRoute(builder: (context) => NumbersBoard()));
  }
}