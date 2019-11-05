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

  //IOS default color palette to be used as theme color choices.
  //ألوان الـIOS الافتراضية، التي ستستخدم كألوان للتطبيق
  static List<Color> appPrimaryColors = <Color>[Colors.red,Colors.orange,Colors.green,Colors.blue, Colors.indigo];

  SharedPreferences profilePreferences ;

  var boardNumbersSubject = BehaviorSubject<BoardNumbers>() ;

  var colorChoiceSubject = BehaviorSubject<int>() ;

  var difficultyLevelSubject = BehaviorSubject<int>() ;

  var localeChoiceSubject = BehaviorSubject<String>() ;

  var editableBlocksSubject = BehaviorSubject<List<String>>() ;

  var userSolutionSubject = BehaviorSubject<List<String>>() ;

  var isThereAPreviousGame = BehaviorSubject<bool>() ;

  var pastGameDurationSubject = BehaviorSubject<int>() ;

  var easyHighScoresSubject = BehaviorSubject<List<String>>() ;

  var mediumHighScoresSubject = BehaviorSubject<List<String>>() ;

  var hardHighScoresSubject = BehaviorSubject<List<String>>() ;


  Stream<MaterialColor> getColor() => colorChoiceSubject.stream.distinct().transform(transformColorChoice) ;

  Stream<Locale> getLocale() => localeChoiceSubject.stream.distinct().transform(transformLocaleChoice) ;

  Stream<List<List<bool>>> getEditableBlocks() => editableBlocksSubject.stream.distinct().transform(transformEditableBlocksList) ;

  Stream<int> getPastGameDuration() => pastGameDurationSubject.stream.distinct() ;

  Stream<List<List<String>>> getUserSolution() => userSolutionSubject.stream.distinct().transform(transformUserSolutionsList) ;

  Stream<bool> getIsThereAPreviousGame() => isThereAPreviousGame.stream.distinct() ;

  Stream<int> getDifficultyLevel() => difficultyLevelSubject.stream.distinct() ;

  Stream<List<String>> getEasyHighScores() => easyHighScoresSubject.stream.distinct() ;

  Stream<List<String>> getMediumHighScores() => mediumHighScoresSubject.stream.distinct() ;

  Stream<List<String>> getHardHighScores() => hardHighScoresSubject.stream.distinct() ;


  void setColorChoice (int colorChoice){
    colorChoiceSubject.sink.add(colorChoice) ;
    //Saving selected color as soon as it is changed.
    //حفظ اللون بمجرد تغييره
    profilePreferences.setInt('Color', colorChoiceSubject.stream.value) ;
  }

  void setLocaleChoice (String languageCode){
    localeChoiceSubject.sink.add(languageCode) ;
    //Saving selected language as soon as it is changed.
    //حفظ اللغة بمجرد تغييرها
    profilePreferences.setString('Locale', localeChoiceSubject.stream.value) ;
  }

  void setEditableBlocks (List<String> editableBlocksList){
    editableBlocksSubject.sink.add(editableBlocksList);
  }

  void setPastGameDuration (int duration){
    pastGameDurationSubject.sink.add(duration);
  }

  void setUserSolution (List<String> userSolutionList){
    userSolutionSubject.sink.add(userSolutionList);
  }

  void setIsThereAPreviousGame(bool isThereAGame){
    isThereAPreviousGame.sink.add(isThereAGame);
  }

  void setDifficultyLevel (int difficulty){
    difficultyLevelSubject.sink.add(difficulty);
    //Saving selected difficulty level as soon as it is changed.
    //حفظ مستوى الصعوبة بمجرد تغييره
    profilePreferences.setInt('Difficulty', difficultyLevelSubject.stream.value) ;
  }

  void setEasyHighScores (List<String> easyHighScore){
    List<String> savedEasyHighScores ;
    savedEasyHighScores = easyHighScoresSubject.stream.value != null ? easyHighScoresSubject.stream.value : List() ;
    savedEasyHighScores.addAll(easyHighScore) ;
    if(savedEasyHighScores.length != 0){
      savedEasyHighScores.sort((a,b) => a.compareTo(b));
      savedEasyHighScores = savedEasyHighScores.sublist(0, savedEasyHighScores.length > 5 ? 5 : savedEasyHighScores.length) ;
    }
    easyHighScoresSubject.sink.add(savedEasyHighScores);
    profilePreferences.setStringList('EasyHighScores', savedEasyHighScores) ;
  }

  void setMediumHighScores (List<String> mediumHighScore){
    List<String> savedMediumHighScores ;
    savedMediumHighScores = mediumHighScoresSubject.stream.value != null ? mediumHighScoresSubject.stream.value : List() ;
    savedMediumHighScores.addAll(mediumHighScore) ;
    if(savedMediumHighScores.length != 0){
      savedMediumHighScores.sort((a,b) => a.compareTo(b));
      savedMediumHighScores = savedMediumHighScores.sublist(0, savedMediumHighScores.length > 5 ? 5 : savedMediumHighScores.length) ;
    }
    mediumHighScoresSubject.sink.add(savedMediumHighScores);
    profilePreferences.setStringList('MediumHighScores', savedMediumHighScores) ;
  }

  void setHardHighScores (List<String> hardHighScore){
    List<String> savedHardHighScores ;
    savedHardHighScores = hardHighScoresSubject.stream.value != null ? hardHighScoresSubject.stream.value : List() ;
    savedHardHighScores.addAll(hardHighScore) ;
    if(savedHardHighScores.length != 0){
      savedHardHighScores.sort((a,b) => a.compareTo(b));
      savedHardHighScores = savedHardHighScores.sublist(0, savedHardHighScores.length > 5 ? 5 : savedHardHighScores.length) ;
      print(savedHardHighScores);
    }
    hardHighScoresSubject.sink.add(savedHardHighScores);
    profilePreferences.setStringList('HardHighScores', savedHardHighScores) ;
  }


  UserDataBloc() {

    _initializeUserFields().then((_){

      _populateUserFields();

    });

  }

  startANewGame() async{

    //cellControllers[(initialNumbers.squares[index].x~/3)*3 + (initialNumbers.squares[index].y~/3)][(initialNumbers.squares[index].y%3) + (initialNumbers.squares[index].x%3)*3].text

    List<List<String>> numbersArray = List.generate(9, (i) => List.generate(9, (j) => '' )) ;

    List<List<bool>> editableFieldsArray = List.generate(9, (i) => List.generate(9, (j) => true )) ;

    List<String> convertedNumbersArray = List(81) ;

    List<String> convertedEditableFieldsArray = List(81) ;

    BoardNumbers initialNumbers = parseNumbers('{"response":true,"size":"9","squares":[{"x":0,"y":1,"value":4},{"x":0,"y":5,"value":7},{"x":0,"y":7,"value":8},{"x":1,"y":0,"value":2},{"x":1,"y":2,"value":7},{"x":1,"y":3,"value":4},{"x":1,"y":5,"value":9},{"x":1,"y":7,"value":5},{"x":2,"y":0,"value":3},{"x":2,"y":4,"value":8},{"x":2,"y":6,"value":4},{"x":2,"y":7,"value":7},{"x":3,"y":2,"value":3},{"x":3,"y":4,"value":5},{"x":3,"y":5,"value":2},{"x":3,"y":6,"value":8},{"x":4,"y":1,"value":6},{"x":4,"y":3,"value":7},{"x":4,"y":4,"value":1},{"x":4,"y":5,"value":3},{"x":4,"y":7,"value":4},{"x":5,"y":0,"value":5},{"x":5,"y":2,"value":2},{"x":5,"y":4,"value":6},{"x":5,"y":6,"value":7},{"x":5,"y":8,"value":9},{"x":6,"y":0,"value":6},{"x":6,"y":1,"value":5},{"x":6,"y":3,"value":2},{"x":6,"y":4,"value":7},{"x":6,"y":6,"value":3},{"x":7,"y":1,"value":3},{"x":7,"y":3,"value":5},{"x":7,"y":5,"value":6},{"x":7,"y":6,"value":1},{"x":8,"y":0,"value":7},{"x":8,"y":1,"value":2},{"x":8,"y":3,"value":3},{"x":8,"y":7,"value":6},{"x":8,"y":8,"value":8}]}');

    if(initialNumbers.response){
      for(int index = 0 ; index < initialNumbers.squares.length ; index++){
        numbersArray[(initialNumbers.squares[index].x~/3)*3 + (initialNumbers.squares[index].y~/3)][(initialNumbers.squares[index].y%3) + (initialNumbers.squares[index].x%3)*3] = initialNumbers.squares[index].value.toString() ;
        editableFieldsArray[(initialNumbers.squares[index].x~/3)*3 + (initialNumbers.squares[index].y~/3)][(initialNumbers.squares[index].y%3) + (initialNumbers.squares[index].x%3)*3] = false ;
      }
    }

    for(int i = 0 ; i < 9 ; i++){
      for(int j = 0 ; j < 9 ; j++){
        convertedNumbersArray[i*9 + j] = numbersArray[i][j] ;
        convertedEditableFieldsArray[i*9 + j] = editableFieldsArray[i][j].toString() ;
      }
    }

    print('fetched numbers are $convertedNumbersArray');

    print('fetched booleans are $convertedEditableFieldsArray');


    setUserSolution(convertedNumbersArray);

    setEditableBlocks(convertedEditableFieldsArray);



  }

  /*Future<BoardNumbers> fetchSudoku(Client client) async {

    final response = await client.get('http://www.cs.utep.edu/cheon/ws/sudoku/new/?size=9&?level=3');

    return parseNumbers(response.body);

    //return parseNumbers('{"response":true,"size":"9","squares":[{"x":0,"y":1,"value":4},{"x":0,"y":5,"value":7},{"x":0,"y":7,"value":8},{"x":1,"y":0,"value":2},{"x":1,"y":2,"value":7},{"x":1,"y":3,"value":4},{"x":1,"y":5,"value":9},{"x":1,"y":7,"value":5},{"x":2,"y":0,"value":3},{"x":2,"y":4,"value":8},{"x":2,"y":6,"value":4},{"x":2,"y":7,"value":7},{"x":3,"y":2,"value":3},{"x":3,"y":4,"value":5},{"x":3,"y":5,"value":2},{"x":3,"y":6,"value":8},{"x":4,"y":1,"value":6},{"x":4,"y":3,"value":7},{"x":4,"y":4,"value":1},{"x":4,"y":5,"value":3},{"x":4,"y":7,"value":4},{"x":5,"y":0,"value":5},{"x":5,"y":2,"value":2},{"x":5,"y":4,"value":6},{"x":5,"y":6,"value":7},{"x":5,"y":8,"value":9},{"x":6,"y":0,"value":6},{"x":6,"y":1,"value":5},{"x":6,"y":3,"value":2},{"x":6,"y":4,"value":7},{"x":6,"y":6,"value":3},{"x":7,"y":1,"value":3},{"x":7,"y":3,"value":5},{"x":7,"y":5,"value":6},{"x":7,"y":6,"value":1},{"x":8,"y":0,"value":7},{"x":8,"y":1,"value":2},{"x":8,"y":3,"value":3},{"x":8,"y":7,"value":6},{"x":8,"y":8,"value":8}]}');

  }*/

  BoardNumbers parseNumbers(String responseBody) {

    var parsed = json.decode(responseBody);

    return BoardNumbers.fromJson(parsed);
  }



  Future _initializeUserFields() async {

    profilePreferences = await SharedPreferences.getInstance() ;

    //BoardNumbers initialNumbers = await fetchSudoku(Client()) ;

    //boardNumbersSubject.sink.add(initialNumbers) ;

  }


  Future _populateUserFields() async {

    if (profilePreferences.getKeys().length > 0) {

        setColorChoice(profilePreferences.getInt('Color') != null ? profilePreferences.getInt('Color') : 0);

        setLocaleChoice(profilePreferences.getString('Locale') != null ? profilePreferences.getString('Locale') : 'en');

        setIsThereAPreviousGame(false);

        setDifficultyLevel(profilePreferences.getInt('Difficulty') != null ? profilePreferences.getInt('Difficulty') : 2);
        
        setEasyHighScores(profilePreferences.getStringList('EasyHighScores') != null ? profilePreferences.getStringList('EasyHighScores') : <String>[]);

        setMediumHighScores(profilePreferences.getStringList('MediumHighScores') != null ? profilePreferences.getStringList('MediumHighScores') : <String>[]);

        setHardHighScores(profilePreferences.getStringList('HardHighScores') != null ? profilePreferences.getStringList('HardHighScores') : <String>[]);

        //Load unfinished solution from storage if there is a one
        //تحميل اللعبة السابقة من وحدة التخزين إذا كانت هنالك واحدة

        if(profilePreferences.getBool('previousGameExist') != null){

          setIsThereAPreviousGame(profilePreferences.getBool('previousGameExist'));

          setEditableBlocks(profilePreferences.getStringList('editableBlocksList') != null ? profilePreferences.getStringList('editableBlocksList') : <String>[]);

          setPastGameDuration(profilePreferences.getInt('gameDuration') != null ? profilePreferences.getInt('gameDuration') : DateTime.now().difference(DateTime.now()).inSeconds);

          setUserSolution(profilePreferences.getStringList('numbersList') != null ? profilePreferences.getStringList('numbersList') : <String>[]);

        }
    }else{
      //In case there's no stored preferences these values will be used
      //في حالة عدم وحود خيارات محفوظة سيتم استخدام هذه القيم

      //Red Color
      //اللون الأحمر
      setColorChoice(0);

      //English language
      //اللغة الانجليزية
      setLocaleChoice('en');

      //No previously stored game
      //لوجود للعبة سابقة
      setIsThereAPreviousGame(false);

      //medium difficulty
      //لعبة متوسطة الصعوبة
      setDifficultyLevel(2);

      //No previous high scores
      //لا توجد درجات عالية
      setEasyHighScores(<String>[]);

      setMediumHighScores(<String>[]);

      setHardHighScores(<String>[]);
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

    //loop inside StreamTransformer wasn't working, so replaced with List.generate() in sink.add().
    //حلقة for لا تعمل داخل StreamTransformer، لذلك استبدلت بـList.generate
    sink.add(List.generate(9, (i) => List.generate(9, (j) => storedEditableList[(i * 9) + j] == 'true' )) );

  });

  final transformUserSolutionsList =
  StreamTransformer<List<String>, List<List<String>>>.fromHandlers(handleData: (storedSolutionList, sink) {

    //loop inside StreamTransformer wasn't working, so replaced with List.generate() in sink.add().
    //حلقة for لا تعمل داخل StreamTransformer، لذلك استبدلت بـList.generate
    sink.add(List.generate(9, (i) => List.generate(9, (j) => storedSolutionList[(i * 9) + j] )) );

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

    pastGameDurationSubject.close() ;

    userSolutionSubject.close() ;

    easyHighScoresSubject.close() ;

    mediumHighScoresSubject.close() ;

    hardHighScoresSubject.close() ;

  }

  saveGameData() async {
    profilePreferences.setStringList('numbersList', userSolutionSubject.stream.value) ;
    profilePreferences.setStringList('editableBlocksList', editableBlocksSubject.stream.value) ;
    profilePreferences.setBool('previousGameExist', isThereAPreviousGame.stream.value) ;
    profilePreferences.setInt('gameDuration', pastGameDurationSubject.stream.value) ;
  }

  deleteOldGame() async {
    profilePreferences.setStringList('numbersList', null) ;
    profilePreferences.setStringList('editableBlocksList', null) ;
    profilePreferences.setBool('previousGameExist', null) ;
    profilePreferences.setInt('gameDuration', null) ;

    editableBlocksSubject = BehaviorSubject<List<String>>() ;

    userSolutionSubject = BehaviorSubject<List<String>>() ;

    pastGameDurationSubject.sink.add(0) ;
  }



}

class UserDataAPIError extends Error {

  final String message;

  UserDataAPIError(this.message);
}


final bloc = UserDataBloc();