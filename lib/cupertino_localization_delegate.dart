import 'package:flutter/cupertino.dart';

class CupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {

  const CupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(CupertinoLocalisationsDelegate old) => false;
}