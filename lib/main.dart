import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animated_button.dart';
import 'app_localizations.dart';
import 'app_localizations_delegate.dart';
import 'bloc_base.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'highscores_page.dart';
import 'instructions_page.dart';
import 'numbers_board.dart';
import 'settings_page.dart';
import 'user_data_bloc.dart';

void main() => runApp(
  BlocProvider(
    bloc: UserDataBloc(),
    child: MyApp(),
  )
);

class MyApp extends StatelessWidget {
  final appTitle = 'Sudoku Game';

  Locale locale;

  @override
  Widget build(BuildContext context) {
    UserDataBloc userBloc = BlocProvider.of(context);


    return StreamBuilder<Locale>(
      stream: userBloc.getLocale(),
      initialData: Locale('en', ''),
      builder: (context, localeSnapshot) {
        if (localeSnapshot.hasData) {
          locale = localeSnapshot.data ;
          return StreamBuilder<Color>(
            stream: userBloc.getColor(),
            initialData: Colors.blue,
            builder: (context, colorSnapshot) {
              if (colorSnapshot.hasData) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Ads App',
                  locale: locale,
                  localizationsDelegates: [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [
                    const Locale('en', ''), // English
                    const Locale('ar', ''), // Arabic
                  ],
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    if (this.locale == null) {
                      this.locale = deviceLocale.languageCode.compareTo('ar') == 0
                          ? supportedLocales.first
                          : supportedLocales.last;

                    }

                    return this.locale;
                  },
                  theme: ThemeData(
                    primarySwatch: colorSnapshot.data,
                    primaryTextTheme: TextTheme(
                      title: TextStyle(color: Colors.white),
                    ),
                    //fontFamily: 'Zain',
                    primaryIconTheme: IconThemeData(color: Colors.white),
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      child: child,
                      // value set to 1.0 to prevent text scaling triggered from device settings, to avoid disrupting app's look and causing layout overflow.
                      data:
                      MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    );
                  },
                  home: MyHomePage(title: appTitle),
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return MaterialApp();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  double easyWidth ;
  double mediumWidth ;
  double hardWidth ;

  @override
  Widget build(BuildContext context) {
    if( (easyWidth == null) | (mediumWidth == null) | (hardWidth == null)){
      easyWidth = mediumWidth = hardWidth =  MediaQuery.of(context).size.width/1.5 ;
    }
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