import 'package:flutter/material.dart';
import 'package:flutter_sudoku/user_data_bloc.dart';

import 'app_localizations.dart';
import 'bloc_base.dart';

class NumbersBoard extends StatefulWidget {

  NumbersBoard({Key key}) : super(key: key);

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

  //to show time spent solving the board, excluding milliseconds.
  //لعرض الزمن الذي تم قضاؤه في حل اللعبة، بدون اظهار الأجزاء من الثانية
  String clock = DateTime.now().difference(DateTime.now()).toString().split('.')[0] ;

  double clockFontSize = 18.0 ;

  double clockTextLength  ;

  //To prevent multiple population of the board.
  //لمنع ملء المربعات بالأرقام أكثر من مرة
  bool boardPopulated = false ;

  bool clockInitialized = false ;

  int pastSeconds = 0 ;

  //Values used to highlight current selected block
  //قيم لإظهار المربع المختار

  int selectedRowPosition = -1 ;

  int selectedColumnPosition = -1 ;

  List<List<bool>> isSelected ;

  @override
  void initState() {
    boxBoardNumbers = List.generate(9, (i) => List.generate(9, (j) => '' )) ;
    horizontalBoardNumbers = List.generate(9, (i) => List.generate(9, (j) => '' )) ;
    verticalBoardNumbers = List.generate(9, (i) => List.generate(9, (j) => '' )) ;
    focusNodes = List.generate(9, (i) => List.generate(9, (i) => FocusNode() )) ;
    isCorrect = List.generate(9, (i) => List.generate(9, (j) => true )) ;
    isEditable = List.generate(9, (i) => List.generate(9, (j) => true )) ;
    isSelected = List.generate(9, (i) => List.generate(9, (j) => false )) ;
    cellControllers = List.generate(9, (i) => List.generate(9, (j) => TextEditingController(text: '') )) ;
    userBloc = BlocProvider.of(context) ;
    moveClock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(AppLocalizations.of(context, pastSeconds == 0 ? 'NewGame' : 'Continue'),),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/numbers_4.jpg'), fit: BoxFit.cover),
        ),
        child: Opacity(
          //Making game board 10% transparent, so the background image'll have a beautiful effect on it.
          //يقوم بجعل لوحة الأرقام شفافة بنسبة عشرة بالمئة ، وذلك لتضفي الخلفية تأثيرا جميلا عليها
          opacity: 0.9,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 30.0, bottom: 20.0, left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //The timer and pause button.
                            //المؤقت و زر الايقاف المؤقت
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2.0, color: Colors.black),
                                //added (2.0) to the radius value to fully wrap the Container child.
                                //تمت اضافة (2.0) لنصف قطر الـContainer وذلك ليحيطها الخط تماما
                                borderRadius: BorderRadius.circular(clockFontSize + 2.0),
                              ),
                              //The purpose of the ClipRRect Widget is to make circular clip to Container's nested Widgets.
                              //الغرض من الـClipRRect هو عمل قطع نصف دائري للـWidgets المدرجة داخل الـContainer
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(clockFontSize),
                                child: Container(
                                  height: clockFontSize*2,
                                  width: clock.length * clockFontSize,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(clockFontSize),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).pop() ;
                                          },
                                          child: Container(
                                            width: clockFontSize*2,
                                            height: clockFontSize*2,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColorDark,
                                              //borderRadius: BorderRadius.circular(clockFontSize),
                                            ),
                                            child: Icon(Icons.pause, color: Colors.white,),
                                          ),
                                        ),
                                        Center(
                                          child: StreamBuilder(
                                            stream: userBloc.getPastGameDuration(),
                                            initialData: 0,
                                            builder: (context, pastDurationSnapshot){
                                              if(!clockInitialized){
                                                initiateClock(pastDurationSnapshot.data) ;
                                              }
                                              return Text(clock, style: TextStyle(fontSize: clockFontSize, color: Colors.black, fontWeight: FontWeight.bold),) ;
                                            },
                                          ),
                                        ),
                                        Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){

                              },
                              child: Container(
                                height: clockFontSize*2,
                                width: clock.length * clockFontSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(clockFontSize),
                                  border: Border.all(width: 2.0, color: Colors.black),
                                ),
                                child: Center(
                                  child: Text(AppLocalizations.of(context, 'ClearAll'), style: TextStyle(fontSize: clockFontSize, color: Colors.red, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //fixing text direction inside the board, so it won't be flipped when changing app language.
                      //جعل اتجاه النص ثابتا، وذلك لكي لا تعكس اللوحة عند تغيير اللغة من الضبط.
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: drawBoard(0.5),
                      ),
                    ],
                  ),
                ],
              ),
              //The Number buttons at the button of the Screen used to fill the Soduko board.
              //أزرار الأرقام في أسفل الشاشة التي تملأ بها خانات السودوكو
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(10, (i) => InkWell(
                      onTap: (){
                        if(selectedRowPosition != -1 && selectedColumnPosition != -1){
                          boxBoardNumbers[selectedRowPosition][selectedColumnPosition] = i != 9 ? (i + 1).toString() : '' ;
                          checkSolution();
                        }
                      },
                      child: Card(
                        elevation: 2.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width/12.5,
                          height: MediaQuery.of(context).size.width/12.5,
                          decoration: BoxDecoration(border: Border.all(width: 2.0, color: Colors.black), borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                              child: i != 9 ? Text((i + 1).toString(), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),) : Icon(Icons.backspace, size: 20.0,)
                          ),
                        ),
                      )
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawBoard(double innerPadding){

    double outerPadding = innerPadding * 6 ;

    return StreamBuilder<bool>(
      stream: userBloc.getIsThereAPreviousGame(),
      initialData: false,
      builder: (context, isThereAPreviousGameSnapshot){
        if(isThereAPreviousGameSnapshot.data){
          for(int i = 0 ; i < 9 ; i++){
            for(int j = 0 ; j < 9 ; j++){
              cellControllers[i][j].text = boxBoardNumbers[i][j] ;
            }
          }
        }
        return StreamBuilder<List<List<String>>>(
          stream: userBloc.getUserSolution(),
          initialData: List.generate(9, (i) => List.generate(9, (j) => '' )),
          builder: (context, userSolutionSnapshot){
            return StreamBuilder<List<List<bool>>>(
              stream: userBloc.getEditableBlocks(),
              initialData: List.generate(9, (i) => List.generate(9, (j) => true )),
              builder: (context, editableBlocksSnapshot){
                if(!boardPopulated && userSolutionSnapshot.hasData){
                  initiateBoard(userSolutionSnapshot.data, editableBlocksSnapshot.data) ;
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width + 12*outerPadding ,
                  padding: EdgeInsets.all(outerPadding),
                  //decoration: BoxDecoration(border: Border.all(width: 2.0, color: Colors.black)),
                  child: GridView.count(
                      crossAxisCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(9, (i){
                        return Container(
                          decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
                          child: GridView.count(
                            crossAxisCount: 3,
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(9, (j) {
                              return isEditable[i][j] ? InkWell(
                                onTap: (){
                                  setState(() {
                                    selectedRowPosition = i ;
                                    selectedColumnPosition = j ;
                                    isSelected = List.generate(9, (i) => List.generate(9, (j) => false )) ;
                                    isSelected[i][j] = true ;
                                  });
                                },
                                child: Center(
                                  child: Stack(
                                    children: <Widget>[
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 6*outerPadding)/3,
                                        height: (MediaQuery.of(context).size.width - 6*outerPadding)/3,
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 100),
                                          curve: Curves.linear,
                                          decoration: BoxDecoration(border: Border.all( width: innerPadding, color: Colors.black), color: !isCorrect[i][j] && boxBoardNumbers[i][j] != '' ? Colors.red : Colors.white),
                                          child: Center(
                                            child: Text(boxBoardNumbers[i][j], style: TextStyle(fontSize: MediaQuery.of(context).size.width/(5*3), fontWeight: FontWeight.bold, color: !isCorrect[i][j] ? Colors.white : Colors.black),),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        child: Container(
                                          width: (MediaQuery.of(context).size.width - 24 )/9,
                                          height: (MediaQuery.of(context).size.width - 24 )/9,
                                          decoration: BoxDecoration(border: Border.all(color: isSelected[i][j] ? ( (isCorrect[i][j] || boxBoardNumbers[i][j] == '') ? Colors.amberAccent : Colors.white) : Colors.transparent, width: 4.0)),
                                        ),
                                      ),
                                    ],
                                  ), ),
                              ) : Center(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.linear,
                                  decoration: BoxDecoration(border: Border.all( width: innerPadding, color: Colors.black), color: !isCorrect[i][j] && boxBoardNumbers[i][j] != '' ?  Colors.red[900] : Colors.grey[350] ),
                                  child: Center(
                                    child: Text(boxBoardNumbers[i][j], style: TextStyle(fontSize: MediaQuery.of(context).size.width/(5*3), fontWeight: FontWeight.bold, color: !isCorrect[i][j] ? Colors.white : Colors.black),),
                                  ),
                                ), );
                            }),
                          ),
                        );
                      })
                  ),
                );
              },
            );

          },
        );
      },
    );
  }

  void initiateClock( int receivedDuration){
    if(receivedDuration != 0){
      print('received time is $receivedDuration');
      pastSeconds = receivedDuration;
      clockInitialized = true ;
    }
  }
  
  void initiateBoard( List<List<String>> receivedNumbers, List<List<bool>> receivedEditables){
    if(receivedNumbers.toString().compareTo(List.generate(9, (i) => List.generate(9, (j) => '' )).toString()) != 0){
      boxBoardNumbers = receivedNumbers ;
      boardPopulated = true ;
    }
    if(receivedEditables.toString().compareTo(List.generate(9, (i) => List.generate(9, (j) => true )).toString()) != 0){
      isEditable = receivedEditables ;
      boardPopulated = true ;
    }
  }




  checkSolution(){

    //List<List<int>> completeSolution = [[1, 4, 5, 2, 8, 7, 3, 9, 6], [6, 2, 7, 4, 3, 9, 1, 8, 5], [9, 8, 3, 6, 5, 1, 4, 7, 2], [4, 7, 3, 8, 6, 9, 5, 1, 2], [9, 5, 2, 7, 1, 3, 8, 6, 4], [8, 1, 6, 2, 4, 5, 7, 3, 9], [6, 5, 1, 9, 3, 8, 7, 2, 4], [2, 7, 8, 5, 4, 6, 3, 9, 1], [3, 9, 4, 1, 2, 7, 5, 6, 8]];

    List<String> horizontalRow = <String>[];

    List<String> verticalColumn = <String>[];

    bool solvedHorizontally = true ;

    bool solvedVertically = true ;

    bool squaresComplete = true ;

    isCorrect = List.generate(9, (i) => List.generate(9, (j) => true )) ;


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


          for(int j = 0 ; j < 9 ; j++){

            if(((boxBoardNumbers[i].indexOf('${j + 1}') != boxBoardNumbers[i].lastIndexOf('${j + 1}')) && boxBoardNumbers[i].indexOf('${j + 1}') != -1) || boxBoardNumbers[i][j] == ''){
              if(boxBoardNumbers[i][j] == ''){
                print('The ${j + 1}th cell of the ${i + 1}th box is empty !');
                isCorrect[i][j] = squaresComplete = false ;
              }
              if ((boxBoardNumbers[i].indexOf('${j + 1}') != boxBoardNumbers[i].lastIndexOf('${j + 1}')) && boxBoardNumbers[i].indexOf('${j + 1}') != -1){
                print('${j + 1} is not unique in the ${i + 1}th box');
                print('first index of ${j + 1 } is : ${boxBoardNumbers[i].indexOf('${j + 1}')}');
                print('last index of ${j + 1 } is : ${boxBoardNumbers[i].lastIndexOf('${j + 1}')}');
                isCorrect[i][boxBoardNumbers[i].indexOf('${j + 1}')] = isCorrect[i][boxBoardNumbers[i].lastIndexOf('${j + 1}')] = squaresComplete = false ;
              }
            }



            if( ((horizontalBoardNumbers[i].indexOf('${j + 1}') != horizontalBoardNumbers[i].lastIndexOf('${j + 1}')) && horizontalBoardNumbers[i].indexOf('${j + 1}') != -1)|| horizontalBoardNumbers[i][j] == ''){
              if(horizontalBoardNumbers[i][j] == ''){
                print('The ${j + 1}th cell of the ${i + 1}th row is empty !');
                for(int a = 0 ; a <  3 ; a++){
                  for(int b = 0 ; b < 3 ; b++){
                    if(boxBoardNumbers[a + 3*(i~/3)][b + 3*(i%3)] == ''){
                      isCorrect[a + 3*(i~/3)][b + 3*(i%3)] = solvedHorizontally = false;
                    }
                  }
                }
              }
              if((horizontalBoardNumbers[i].indexOf('${j + 1}') != horizontalBoardNumbers[i].lastIndexOf('${j + 1}')) && horizontalBoardNumbers[i].indexOf('${j + 1}') != -1){
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




            if( ((verticalBoardNumbers[i].indexOf('${j + 1}') != verticalBoardNumbers[i].lastIndexOf('${j + 1}')) && verticalBoardNumbers[i].indexOf('${j + 1}') != -1) || verticalBoardNumbers[i][j] == ''){
              if(verticalBoardNumbers[i][j] == ''){
                print('The ${j + 1}th cell of the ${i + 1}th column is empty !');
                for(int x = 0 ; x < 9 ; x = x + 3){
                  for(int y = 0 ; y < 9 ; y = y + 3){
                    if(boxBoardNumbers[x + (i~/3)][y + (i%3)] == ''){
                      isCorrect[x + (i~/3)][y + (i%3)] = solvedVertically = false;
                    }
                  }
                }
              }
              if((verticalBoardNumbers[i].indexOf('${j + 1}') != verticalBoardNumbers[i].lastIndexOf('${j + 1}')) && verticalBoardNumbers[i].indexOf('${j + 1}') != -1){
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

        print('Horizotally : $solvedHorizontally');
        print('Vertically : $solvedVertically');
        print('Squares : $squaresComplete');

    print((solvedHorizontally & solvedVertically & squaresComplete) ? 'Congratulations !' : 'Incorrect solution ! please try again');

  }

  moveClock() async {

    Future.delayed( Duration(seconds: 1), (){
      currentTime = DateTime.now().add(Duration(seconds: pastSeconds)) ;
      if(!gameClosing){
        setState(() {
          clock = currentTime.difference(beginningTime).abs().toString().split('.')[0] ;
          //To make Container's width proportional to text length
          //يقوم هذا السطر بتغيير عرض الـContainer ليكون نسبيا مع عدد الأرقام الظاهرة
          clockTextLength = clock.length.toDouble() ;
        });
      }
      //Doing initial check to highlight wrong answers when resuming game
      //لتوضيح الاجابات الخاطئة عندما يتم متابعة لعبة سابقة
      if(DateTime.now().difference(beginningTime).inSeconds == 2 && pastSeconds != 0){
        checkSolution() ;
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