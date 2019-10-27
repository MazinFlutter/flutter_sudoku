import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'bloc_base.dart';
import 'user_data_bloc.dart';




class SettingsPageContent extends StatefulWidget {
  @override
  _SettingsPageContentState createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<SettingsPageContent>{
  UserDataBloc userBloc ;

  int levelSelection = 0 ;


  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return ListView(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child:  Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30.0, bottom: 40.0,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context, 'LanguagesAndThemes'), style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(AppLocalizations.of(context, 'Language'), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('English'),
                            StreamBuilder<Locale>(
                              stream: userBloc.getLocale(),
                              initialData: Locale('en',''),
                              builder: (BuildContext context, localeSnapshot){
                                return Radio(value: 0, groupValue: localeSnapshot.data.languageCode == 'en' ? 0 : 1, onChanged: handleRadioLocaleChange, activeColor: Colors.blue,);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('العربية'),
                            StreamBuilder<Locale>(
                              stream: userBloc.getLocale(),
                              initialData: Locale('en',''),
                              builder: (BuildContext context, localeSnapshot){
                                return Radio(value: 1, groupValue: localeSnapshot.data.languageCode == 'en' ? 0 : 1, onChanged: handleRadioLocaleChange, activeColor: Colors.blue,);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(AppLocalizations.of(context, 'Difficulty'), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                    ],
                  )
              ),
              CupertinoSegmentedControl(
                groupValue: levelSelection,
                unselectedColor: Colors.transparent,
                children: <int, Widget>{
                  0 : FlatButton(
                    child: Text(AppLocalizations.of(context, 'Easy')),
                    onPressed: (){
                      setState(() {
                        levelSelection = 0 ;
                      });
                    },
                  ),
                  1 : FlatButton(
                    child: Text(AppLocalizations.of(context, 'Medium')),
                    onPressed: (){
                      setState(() {
                        levelSelection = 1 ;
                      });
                    },
                  ),
                  2 : FlatButton(
                    child: Text(AppLocalizations.of(context, 'Hard')),
                    onPressed: (){
                      setState(() {
                        levelSelection = 2 ;
                      });
                    },
                  ),
                },
                onValueChanged: (int value){
                },
              )
            ],
          ),
        ),

      ],
    );
  }

  void handleRadioLocaleChange (int value) {
    userBloc.setLocaleChoice(value == 0 ? 'en' : 'ar') ;
  }

}