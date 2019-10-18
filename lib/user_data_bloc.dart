import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc_base.dart';
import 'package:http/http.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'board_numbers.dart';


class UserDataBloc extends BlocBase{

  static List<Color> appPrimaryColors = <Color>[Colors.cyan,Colors.orange,Colors.blue,Colors.red, Colors.purple];

  SharedPreferences profilePreferences ;

  var boardNumbersSubject = BehaviorSubject<BoardNumbers>() ;

  var colorChoiceSubject = BehaviorSubject<int>() ;

  var difficultyLevelSubject = BehaviorSubject<int>() ;

  var localeChoiceSubject = BehaviorSubject<String>() ;


  Stream<MaterialColor> getColor() => colorChoiceSubject.stream.distinct().transform(transformColorChoice) ;

  Stream<Locale> getLocale() => localeChoiceSubject.stream.distinct().transform(transformLocaleChoice) ;


  void setColorChoice (int colorChoice){
    colorChoiceSubject.sink.add(colorChoice) ;
  }

  void setLocaleChoice (String languageCode){
    localeChoiceSubject.sink.add(languageCode) ;
  }


  UserDataBloc() {

    _initializeUserFields().then((_){

      _populateUserFields();

    });

  }

  Future<BoardNumbers> fetchSudoku(Client client) async {

    //final response = await client.get('http://www.cs.utep.edu/cheon/ws/sudoku/new/?size=9&?level=3');

    //return parseNumbers(response.body);

    return parseNumbers('{"response":true,"size":"9","squares":[{"x":0,"y":1,"value":4},{"x":0,"y":5,"value":7},{"x":0,"y":7,"value":8},{"x":1,"y":0,"value":2},{"x":1,"y":2,"value":7},{"x":1,"y":3,"value":4},{"x":1,"y":5,"value":9},{"x":1,"y":7,"value":5},{"x":2,"y":0,"value":3},{"x":2,"y":4,"value":8},{"x":2,"y":6,"value":4},{"x":2,"y":7,"value":7},{"x":3,"y":2,"value":3},{"x":3,"y":4,"value":5},{"x":3,"y":5,"value":2},{"x":3,"y":6,"value":8},{"x":4,"y":1,"value":6},{"x":4,"y":3,"value":7},{"x":4,"y":4,"value":1},{"x":4,"y":5,"value":3},{"x":4,"y":7,"value":4},{"x":5,"y":0,"value":5},{"x":5,"y":2,"value":2},{"x":5,"y":4,"value":6},{"x":5,"y":6,"value":7},{"x":5,"y":8,"value":9},{"x":6,"y":0,"value":6},{"x":6,"y":1,"value":5},{"x":6,"y":3,"value":2},{"x":6,"y":4,"value":7},{"x":6,"y":6,"value":3},{"x":7,"y":1,"value":3},{"x":7,"y":3,"value":5},{"x":7,"y":5,"value":6},{"x":7,"y":6,"value":1},{"x":8,"y":0,"value":7},{"x":8,"y":1,"value":2},{"x":8,"y":3,"value":3},{"x":8,"y":7,"value":6},{"x":8,"y":8,"value":8}]}');

  }

  BoardNumbers parseNumbers(String responseBody) {

    var parsed = json.decode(responseBody);


    return BoardNumbers.fromJson(parsed);
  }



  Future _initializeUserFields() async {

    profilePreferences = await SharedPreferences.getInstance() ;

    BoardNumbers initialNumbers = await fetchSudoku(Client()) ;

    boardNumbersSubject.sink.add(initialNumbers) ;

  }


  Future _populateUserFields() async {

    //profilePreferences = await SharedPreferences.getInstance() ;

    if (profilePreferences.getKeys().length > 0) {

        setColorChoice(profilePreferences.getInt('Color') != null ? profilePreferences.getInt('Color') : 0);

        setLocaleChoice(profilePreferences.getString('Locale') != null ? profilePreferences.getString('Locale') : 'en');

    }

  }



  final transformColorChoice =
  StreamTransformer<int, MaterialColor>.fromHandlers(handleData: (colorChoice, sink) {

    if(colorChoice >= 0 && colorChoice < 5){
      sink.add(appPrimaryColors[colorChoice]);
    }else{
      sink.addError('Invalid Color Choice');
    }

  });

  final transformLocaleChoice =
  StreamTransformer<String, Locale>.fromHandlers(handleData: (languageChoice, sink) {

    if(languageChoice == 'ar' || languageChoice == 'en'){

      sink.add(Locale(languageChoice,''));

    }else{

      sink.addError('Invalid language code');

    }

  });

  Future<bool> userDataExist() async{

    await Future.delayed(const Duration(seconds: 2), () {

    });

    return profilePreferences.getKeys().length > 0 ;

  }


  @override
  void dispose() {

    // close our StreamControllers

    boardNumbersSubject.close() ;

    colorChoiceSubject.close() ;

    difficultyLevelSubject.close() ;

    localeChoiceSubject.close() ;

  }

  saveSettings() async {
    profilePreferences.setString('Locale',localeChoiceSubject.stream.value);
    profilePreferences.setInt('Color', colorChoiceSubject.stream.value);
  }



}

class UserDataAPIError extends Error {

  final String message;

  UserDataAPIError(this.message);
}


final bloc = UserDataBloc();