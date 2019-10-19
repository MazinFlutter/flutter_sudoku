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

  var editableBlocksSubject = BehaviorSubject<List<String>>() ;

  var userSolutionSubject = BehaviorSubject<List<String>>() ;

  var isThereAPreviousGame = BehaviorSubject<bool>() ;


  Stream<MaterialColor> getColor() => colorChoiceSubject.stream.distinct().transform(transformColorChoice) ;

  Stream<Locale> getLocale() => localeChoiceSubject.stream.distinct().transform(transformLocaleChoice) ;

  Stream<List<List<bool>>> getEditableBlocks() => editableBlocksSubject.stream.distinct().transform(transformEditableBlocksList) ;

  Stream<List<List<String>>> getUserSolution() => userSolutionSubject.stream.distinct().transform(transformUserSolutionsList) ;

  Stream<bool> getIsThereAPreviousGame() => isThereAPreviousGame.stream.distinct() ;


  void setColorChoice (int colorChoice){
    colorChoiceSubject.sink.add(colorChoice) ;
  }

  void setLocaleChoice (String languageCode){
    localeChoiceSubject.sink.add(languageCode) ;
  }

  void setEditableBlocks (List<String> editableBlocksList){
    editableBlocksSubject.sink.add(editableBlocksList);
  }

  void setUserSolution (List<String> userSolutionList){
    userSolutionSubject.sink.add(userSolutionList);
  }

  void setIsThereAPreviousGame(bool isThereAGame){
    isThereAPreviousGame.sink.add(isThereAGame);
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

    if (profilePreferences.getKeys().length > 0) {

        setColorChoice(profilePreferences.getInt('Color') != null ? profilePreferences.getInt('Color') : 0);

        setLocaleChoice(profilePreferences.getString('Locale') != null ? profilePreferences.getString('Locale') : 'en');

        //Load unfinished solution from storage if there is a one
        //تحميل اللعبة السابقة من وحدة التخزين إذا كانت هنالك واحدة

        if(profilePreferences.getBool('previousGameExist') != null){

          setIsThereAPreviousGame(profilePreferences.getBool('previousGameExist'));

          setEditableBlocks(profilePreferences.getStringList('editableBlocksList') != null ? profilePreferences.getStringList('editableBlocksList') : <String>[]);

          setUserSolution(profilePreferences.getStringList('numbersList') != null ? profilePreferences.getStringList('numberList') : <String>[]);

        }
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

  final transformEditableBlocksList =
  StreamTransformer<List<String>, List<List<bool>>>.fromHandlers(handleData: (storedEditableList, sink) {

    List<List<bool>> convertedEditableBlocksList ;

    if(storedEditableList.length == 81){

      for(int i = 0 ; i < 9 ; i++){
        convertedEditableBlocksList[i] = List.generate(9, (j) => storedEditableList[(i * 9) + j] == 'true').toList() ;
      }

      sink.add(convertedEditableBlocksList) ;

    }else{

      sink.addError('Invalid Editable blocks List');

    }

  });

  final transformUserSolutionsList =
  StreamTransformer<List<String>, List<List<String>>>.fromHandlers(handleData: (storedSolutionList, sink) {

    List<List<String>> convertedSolutionList ;

    if(storedSolutionList.length == 81){

      for(int i = 0 ; i < 9 ; i++){
        convertedSolutionList[i] = List.generate(9, (j) => storedSolutionList[(i * 9) + j]).toList() ;
      }

      sink.add(convertedSolutionList) ;

    }else{

      sink.addError('Invalid Solutions List');

    }

  });

  Future<bool> userDataExist() async{

    await Future.delayed(const Duration(seconds: 2), () {

    });

    return profilePreferences.getKeys().length > 0 ;

  }


  @override
  void dispose() {

    // close our StreamControllers to release resources when closing the app.
    //تحرير الذاكرة المخصصة لتخزين الـStream Controllers عند إعلاق اللعبة

    boardNumbersSubject.close() ;

    colorChoiceSubject.close() ;

    difficultyLevelSubject.close() ;

    editableBlocksSubject.close() ;

    isThereAPreviousGame.close() ;

    localeChoiceSubject.close() ;

    userSolutionSubject.close() ;

  }

  saveSettings() async {
    profilePreferences.setString('Locale',localeChoiceSubject.stream.value) ;
    profilePreferences.setInt('Color', colorChoiceSubject.stream.value) ;
  }

  saveGameData() async {
    profilePreferences.setStringList('numbersList', userSolutionSubject.stream.value) ;
    profilePreferences.setStringList('editableBlocksList', editableBlocksSubject.stream.value) ;
    profilePreferences.setBool('previousGameExist', isThereAPreviousGame.stream.value) ;
  }



}

class UserDataAPIError extends Error {

  final String message;

  UserDataAPIError(this.message);
}


final bloc = UserDataBloc();