import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_localizations_delegate.dart';
import 'bloc_base.dart';
import 'cupertino_localization_delegate.dart';
import 'home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'user_data_bloc.dart';


///Main App Page.


//App is forced to used portrait mode only irrespective of the device orientation.
//التطبيق يعمل في الوضع الرأسي فقط بغض النظر عن وضعية الجهاز.
void main() =>  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
    .then((_) {
      runApp(
      BlocProvider(
        bloc: UserDataBloc(),
        child: MyApp(),
      )
  );
});

class MyApp extends StatefulWidget {

  final appTitle ;

  MyApp({Key key, this.appTitle}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp>{

  Locale locale ;

  UserDataBloc userBloc ;

  @override
  Widget build(BuildContext context) {

    userBloc = BlocProvider.of(context);

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
                    CupertinoLocalisationsDelegate(),
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
                  home: MyHomePage(title: widget.appTitle),
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