import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'settings_page_content.dart';



class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => new  _SettingsPageState() ;
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context, 'SettingsPageTitle')),
      ),
      body: Container(
        /*decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/numbers_1.png'), fit: BoxFit.cover),
        ),*/
        child: SettingsPageContent(),
      )
    );
  }
}