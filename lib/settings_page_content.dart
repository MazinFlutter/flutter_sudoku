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


  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return OrientationBuilder(
        builder: (context, orientation){
          return ListView(
            children: <Widget>[
              Container(
                height: orientation == Orientation.portrait ? MediaQuery.of(context).size.height :  MediaQuery.of(context).size.width/1.2 ,
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
                            Text(AppLocalizations.of(context, 'Theme'),style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                        children: <Widget>[
                          InkWell(
                            child: StreamBuilder(
                              stream: userBloc.getColor(),
                              builder: (BuildContext context, colorSnapshot){
                                return Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorSnapshot.data == Colors.cyan ? Colors.green : Colors.grey , width: 4.0),
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: UserDataBloc.appPrimaryColors[0] ,
                                  ),
                                );
                              },
                            ),
                            onTap: (){
                              userBloc.setColorChoice(0) ;
                            },
                          ),
                          InkWell(
                            child: StreamBuilder(
                              stream: userBloc.getColor(),
                              builder: (BuildContext context, colorSnapshot){
                                return Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorSnapshot.data == Colors.orange ? Colors.green : Colors.grey , width: 4.0),
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: UserDataBloc.appPrimaryColors[1] ,
                                  ),
                                );
                              },
                            ),
                            onTap: (){
                              userBloc.setColorChoice(1) ;
                            },
                          ),
                          InkWell(
                            child: StreamBuilder(
                              stream: userBloc.getColor(),
                              builder: (BuildContext context, colorSnapshot){
                                return Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorSnapshot.data == Colors.blue ? Colors.green : Colors.grey , width: 4.0),
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: UserDataBloc.appPrimaryColors[2] ,
                                  ),
                                );
                              },
                            ),
                            onTap: (){
                              userBloc.setColorChoice(2) ;
                            },
                          ),
                          InkWell(
                            child: StreamBuilder(
                              stream: userBloc.getColor(),
                              builder: (BuildContext context, colorSnapshot){
                                return Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorSnapshot.data == Colors.red ? Colors.green : Colors.grey , width: 4.0),
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: UserDataBloc.appPrimaryColors[3] ,
                                  ),
                                );
                              },
                            ),
                            onTap: (){
                              userBloc.setColorChoice(3) ;
                            },
                          ),
                          InkWell(
                            child: StreamBuilder(
                              stream: userBloc.getColor(),
                              builder: (BuildContext context, colorSnapshot){
                                return Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorSnapshot.data == Colors.purple ? Colors.green : Colors.grey , width: 4.0),
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: UserDataBloc.appPrimaryColors[4] ,
                                  ),
                                );
                              },
                            ),
                            onTap: (){
                              userBloc.setColorChoice(4) ;
                            },
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
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(AppLocalizations.of(context, 'Easy'), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
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
                                  Text(AppLocalizations.of(context, 'Medium'), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
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
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(AppLocalizations.of(context, 'Hard'), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
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
                  ],
                ),
              ),

            ],
          );
        });
  }

  void handleRadioLocaleChange (int value) {
    userBloc.setLocaleChoice(value == 0 ? 'en' : 'ar') ;
  }

}