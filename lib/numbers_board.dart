import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sudoku/user_data_bloc.dart';

import 'animated_button.dart';
import 'app_localizations.dart';
import 'bloc_base.dart';

class NumbersBoard extends StatefulWidget {

  @required
  final bool previousDataExist ;

  NumbersBoard({Key key, this.previousDataExist}) : super(key: key);

  @override
  _NumbersBoardState createState() => _NumbersBoardState();

}

class _NumbersBoardState extends State<NumbersBoard>{

  final int boardSizeDivisor = 10 ;

  bool currentlyChecking = false ;

  bool gameClosing = false ;

  List<List<String>> boxBoardNumbers ;

  List<List<int>> modelAnswer ;

  List<List<String>> horizontalBoardNumbers ;

  List<List<String>> verticalBoardNumbers ;

  List<List<FocusNode>> focusNodes ;

  List<List<bool>> isCorrect ;

  List<List<bool>> isEditable ;

  List<List<TextEditingController>> cellControllers ;

  UserDataBloc userBloc ;

  DateTime beginningTime = DateTime.now();

  DateTime currentTime = DateTime.now();

  String clock = DateTime.now().difference(DateTime.now()).toString().split('.')[0] ;

  double clockFontSize = 18.0 ;

  double clockTextLength  ;

  @override
  void initState() {
    boxBoardNumbers = List.generate(9, (i) => List.generate(9, (j) => '' )) ;
    horizontalBoardNumbers = List.generate(9, (i) => List.generate(9, (i) => '' )) ;
    verticalBoardNumbers = List.generate(9, (i) => List.generate(9, (i) => '' )) ;
    focusNodes = List.generate(9, (i) => List.generate(9, (i) => FocusNode() )) ;
    isCorrect = List.generate(9, (i) => List.generate(9, (i) => true )) ;
    isEditable = List.generate(9, (i) => List.generate(9, (i) => true )) ;
    cellControllers = List.generate(9, (i) => List.generate(9, (j) => TextEditingController(text: '') )) ;
    userBloc = BlocProvider.of(context) ;
    moveClock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/numbers_5.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<BoardNumbers>(
              stream: userBloc.boardNumbersSubject,
              builder: (context, initialNumbersSnapshot){
                if(initialNumbersSnapshot.hasData){
                  return drawBoard(0.5, initialNumbersSnapshot.data, widget.previousDataExist);
                }else{
                  return CircularProgressIndicator();
                }
              },
            ),
            Opacity(
              opacity: 0.7,
              child: Container(
                height: clockFontSize*2,
                width: clock.length * clockFontSize/ 1.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(clockFontSize),
                ),
                child: Center(
                  child: Text(clock, style: TextStyle(fontSize: clockFontSize,),),
                ),
              ),
            ),
            AnimatedButton(title: AppLocalizations.of(context, 'CheckSolution'), onPressed: (){
              checkSolution();
            }),
            Container(),
          ],
        ),
      ),
    );
  }

  Widget drawBoard(double innerPadding, BoardNumbers numbers, bool previousGameExist){

    double outerPadding = innerPadding * 6 ;

    return StreamBuilder<bool>(
      stream: userBloc.getIsThereAPreviousGame(),
      initialData: false,
      builder: (context, isThereAPreviousGameSnapshot){
        if(isThereAPreviousGameSnapshot.data){
          boxBoardNumbers = userBloc.userSolution ;
          isEditable = userBloc.editableBlocks ;
          for(int i = 0 ; i < 9 ; i++){
            for(int j = 0 ; j < 9 ; j++){
              cellControllers[i][j].text = boxBoardNumbers[i][j] ;
            }
          }
        }else{
          if(numbers.response){
            for(int index = 0 ; index < numbers.squares.length ; index++){
              boxBoardNumbers[(numbers.squares[index].x~/3)*3 + (numbers.squares[index].y~/3)][(numbers.squares[index].y%3) + (numbers.squares[index].x%3)*3] = cellControllers[(numbers.squares[index].x~/3)*3 + (numbers.squares[index].y~/3)][(numbers.squares[index].y%3) + (numbers.squares[index].x%3)*3].text = numbers.squares[index].value.toString() ;
              isEditable[(numbers.squares[index].x~/3)*3 + (numbers.squares[index].y~/3)][(numbers.squares[index].y%3) + (numbers.squares[index].x%3)*3] = false ;
            }
          }
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width + 6*outerPadding ,
          padding: EdgeInsets.all(3.0),
          child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (i){
                return GridView.count(
                  crossAxisCount: 3,
                  padding: EdgeInsets.all(outerPadding),
                  children: List.generate(9, (j) {
                    return Center(
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          width: MediaQuery.of(context).size.width/3,
                          height: MediaQuery.of(context).size.width/3,
                          decoration: BoxDecoration(border: Border.all( width: innerPadding, color: Colors.lightBlueAccent), color: currentlyChecking && isEditable[i][j] ? (isCorrect[i][j] ? (isEditable[i][j] ? Colors.white : Colors.grey[300]) : Colors.red[300]) : focusNodes[i][j].hasFocus ? Colors.blue[100] : isEditable[i][j] ? Colors.white : Colors.grey[300] ),
                          child: TextField(enabled: isEditable[i][j], controller: cellControllers[i][j], focusNode: focusNodes[i][j], decoration: InputDecoration(isDense: false, border: InputBorder.none),textAlign: TextAlign.center, textAlignVertical: TextAlignVertical.center, enableInteractiveSelection: false,keyboardType: TextInputType.number,showCursor: false,style: TextStyle(fontSize: MediaQuery.of(context).size.width/(6*3), fontWeight: FontWeight.bold),inputFormatters: [LengthLimitingTextInputFormatter(1)], onChanged: (value){

                            boxBoardNumbers[i][j] = cellControllers[i][j].text = !'123456789'.contains(value) ? '': value  ;
                          }, onTap: (){
                            setState(() {

                            });
                          }),
                        ),
                      ), );
                  }),
                );
              })
          ),
        );
      },
    );
  }




  checkSolution(){

    //List<List<int>> completeSolution = [[1, 4, 5, 2, 8, 7, 3, 9, 6], [6, 2, 7, 4, 3, 9, 1, 8, 5], [9, 8, 3, 6, 5, 1, 4, 7, 2], [4, 7, 3, 8, 6, 9, 5, 1, 2], [9, 5, 2, 7, 1, 3, 8, 6, 4], [8, 1, 6, 2, 4, 5, 7, 3, 9], [6, 5, 1, 9, 3, 8, 7, 2, 4], [2, 7, 8, 5, 4, 6, 3, 9, 1], [3, 9, 4, 1, 2, 7, 5, 6, 8]];

    print(boxBoardNumbers);

    List<String> horizontalRow = <String>[];

    List<String> verticalColumn = <String>[];

    List<String> numberSquare = <String>[];

    bool solvedHorizontally = true ;

    bool solvedVertically = true ;

    bool squaresComplete = true ;

    isCorrect = List.generate(9, (i) => List.generate(9, (i) => true )) ;


        for(int i = 0 ; i < 9 ; i++){

          horizontalRow.clear();

          verticalColumn.clear();


          for(int x = 0 ; x < 9 ; x = x + 3){
            for(int y = 0 ; y < 9 ; y = y + 3){
              verticalColumn.add(boxBoardNumbers[x + (i~/3)][y + (i%3)]);
            }
          }

          for(int a = 0 ; a <  3 ; a++){
            for(int b = 0 ; b < 3 ; b++){
              horizontalRow.add(boxBoardNumbers[a + 3*(i~/3)][b + 3*(i%3)]);
            }
          }

          horizontalBoardNumbers[i] = horizontalRow.toList();

          verticalBoardNumbers[i] = verticalColumn.toList() ;

            numberSquare = List.generate(9, (x) => boxBoardNumbers[i][x]);
            print('squares array  is : \n $numberSquare');

          for(int j = 0 ; j < 9 ; j++){

            if(((boxBoardNumbers[i].indexOf('${j + 1}') != boxBoardNumbers[i].lastIndexOf('${j + 1}')) && boxBoardNumbers[i].indexOf('${j + 1}') != -1) || boxBoardNumbers[i][j] == ''){
              if(boxBoardNumbers[i][j] == ''){
                print('The ${j + 1}th cell of the ${i + 1}th box is empty !');
                isCorrect[i][j] = squaresComplete = false ;
              }else{
                print('${j + 1} is not unique in the ${i + 1}th box');
                print('first index of ${j + 1 } is : ${boxBoardNumbers[i].indexOf('${j + 1}')}');
                print('last index of ${j + 1 } is : ${boxBoardNumbers[i].lastIndexOf('${j + 1}')}');
                isCorrect[i][boxBoardNumbers[i].indexOf('${j + 1}')] = isCorrect[i][boxBoardNumbers[i].lastIndexOf('${j + 1}')] = squaresComplete = false ;
              }
            }




            if( (horizontalBoardNumbers[i].indexOf('${j + 1}') != horizontalBoardNumbers[i].lastIndexOf('${j + 1}')) || horizontalBoardNumbers[i][j] == ''){
              if(horizontalBoardNumbers[i][j] == ''){
                print('The ${j + 1}th cell of the ${i + 1}th row is empty !');
                for(int a = 0 ; a <  3 ; a++){
                  for(int b = 0 ; b < 3 ; b++){
                    if(boxBoardNumbers[a + 3*(i~/3)][b + 3*(i%3)] == ''){
                      isCorrect[a + 3*(i~/3)][b + 3*(i%3)] = solvedHorizontally = false;
                    }
                  }
                }
              }else{
                print('${j + 1} is not unique in the ${i + 1}th row');
                print('first index of ${j + 1 } is : ${horizontalBoardNumbers[i].indexOf('${j + 1}')}');
                print('last index of ${j + 1 } is : ${horizontalBoardNumbers[i].lastIndexOf('${j + 1}')}');
                for(int a = 0 ; a <  3 ; a++){
                  for(int b = 0 ; b < 3 ; b++){
                    if(boxBoardNumbers[a + 3*(i~/3)][b + 3*(i%3)] == '${j + 1}'){
                      isCorrect[a + 3*(i~/3)][b + 3*(i%3)] = solvedHorizontally = false;
                    }
                  }
                }
              }
            }




            if( (verticalBoardNumbers[i].indexOf('${j + 1}') != verticalBoardNumbers[i].lastIndexOf('${j + 1}')) || verticalBoardNumbers[i][j] == ''){
              if(verticalBoardNumbers[i][j] == ''){
                print('The ${j + 1}th cell of the ${i + 1}th column is empty !');
                for(int x = 0 ; x < 9 ; x = x + 3){
                  for(int y = 0 ; y < 9 ; y = y + 3){
                    if(boxBoardNumbers[x + (i~/3)][y + (i%3)] == ''){
                      isCorrect[x + (i~/3)][y + (i%3)] = solvedVertically = false;
                    }
                  }
                }
              }else{
                print('${j + 1} is not unique in the ${i + 1}th column');
                print('first index of ${j + 1 } is : ${verticalBoardNumbers[i].indexOf('${j + 1}')}');
                print('last index of ${j + 1 } is : ${verticalBoardNumbers[i].lastIndexOf('${j + 1}')}');
                for(int x = 0 ; x < 9 ; x = x + 3){
                  for(int y = 0 ; y < 9 ; y = y + 3){
                    if(boxBoardNumbers[x + (i~/3)][y + (i%3)] == '${j + 1}'){
                      isCorrect[x + (i~/3)][y + (i%3)] = solvedVertically = false;
                    }
                  }
                }
              }
            }




          }
        }

        showAnswer();

        print('Horizotally : $solvedHorizontally');
        print('Vertically : $solvedVertically');
        print('Squares : $squaresComplete');

    print((solvedHorizontally & solvedVertically & squaresComplete) ? 'Congratulations !' : 'Incorrect solution ! please try again');

  }

  showAnswer() async {
    print('box array is : \n $boxBoardNumbers');
    print('horizontal array is : \n $horizontalBoardNumbers');
    print('vertical array is : \n $verticalBoardNumbers');
    setState(() {
      currentlyChecking = true ;
    });

    Future.delayed( Duration(seconds: 2), (){
      setState(() {
        currentlyChecking = false ;
      });

    });
  }

  moveClock() async {

    Future.delayed( Duration(seconds: 1), (){
      currentTime = widget.previousDataExist ? DateTime.now().add(Duration(seconds: userBloc.pastGameDuration)) : DateTime.now() ;
      if(!gameClosing){
        setState(() {
          clock = currentTime.difference(beginningTime).toString().split('.')[0] ;
          //To make Container's width proportional to text length
          //يقوم هذا السطر بتغيير عرض الـContainer ليكون نسبيا مع عدد الأرقام الظاهرة
          clockTextLength = clock.length.toDouble() ;
        });
      }

      moveClock();

    });
  }

  void saveUnfinishedSolution(List<List<String>> numbers, List<List<bool>> areEditableList, UserDataBloc userBloc){

    List<String> convertedNumbers = <String>[] ;

    List<String> convertedEditableList = <String>[] ;

    for(int i = 0 ; i < 9 ; i++){
      for(int j = 0 ; j < 9 ; j++){
        convertedNumbers.add(numbers[i][j]);
        convertedEditableList.add(areEditableList[i][j].toString());
      }
    }

    userBloc.setUserSolution(convertedNumbers) ;
    userBloc.setEditableBlocks(convertedEditableList) ;
    userBloc.setIsThereAPreviousGame(true) ;
    userBloc.setPastGameDuration(currentTime.difference(beginningTime).inSeconds) ;
    userBloc.saveGameData() ;
  }

    @override
  void dispose() {
    gameClosing = true ;
    saveUnfinishedSolution(boxBoardNumbers, isEditable, userBloc) ;
    print('Game disposed !') ;
    super.dispose() ;
  }

}
