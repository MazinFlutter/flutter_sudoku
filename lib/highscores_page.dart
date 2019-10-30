import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/app_localizations.dart';

class HighScoresPage extends StatefulWidget {

  HighScoresPage({Key key,}) : super(key: key);

  @override
  _HighScoresPageState createState() => _HighScoresPageState();

}

class _HighScoresPageState extends State<HighScoresPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context, 'HighScores')),),
      body: Center(child: Text('HighScores Page')),
    );
  }
}