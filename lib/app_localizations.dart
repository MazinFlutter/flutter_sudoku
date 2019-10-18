import 'package:flutter/material.dart';

/// This class is responsible for storing localized values for most strings used in the application
///
/// it provides the suitable value for key passed depending on the current locale. The languages supported are English and Arabic.
class AppLocalizations {
  AppLocalizations(this.locale);

  // Application's current locale
  final Locale locale;

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'Title' : 'Sudoku',
      //Main Menu Strings
      'Continue' : 'Continue',
      'NewGame' : 'New Game',
      'HighScores' : 'High Scores',
      'Settings' : 'Settings',
      'Instructions' : 'Instructions',
      'Exit' : 'Exit',
      //Game Strings
      'CheckSolution' : 'Check Solution',
      //Settings Page Strings
      'SettingsPageTitle' : 'Settings',
      'LanguagesAndThemes' : 'Languages and Themes',
      'Language' : 'Language',
      'Theme' : 'Theme',
      'Difficulty' : 'Difficulty',
      'Easy' : 'Easy',
      'Medium' : 'Medium',
      'Hard' : 'Hard',

    },
    'ar': {
      'Title' : 'سودوكو',
      //Main Menu Strings
      'Continue' : 'متابعة',
      'NewGame' : 'لعبة جديدة',
      'HighScores' : 'درجات عالية',
      'Settings' : 'الضبط',
      'Instructions' : 'تعليمات',
      'Exit' : 'خروج',
      //Game Strings
      'CheckSolution' : 'تحقق من الحل',
      //Settings Page Strings
      'SettingsPageTitle' : 'الضبط',
      'LanguagesAndThemes' : 'اللغات والموضوعات',
      'Language' : 'اللغة',
      'Theme' : 'الموضوع',
      'Difficulty' : 'مستوى الصعوبة',
      'Easy' : 'سهل',
      'Medium' : 'متوسط',
      'Hard' : 'صعب',
    }
  };

  /// Used to retrieve the string value for the passed key
  String translate(key) {
    return _localizedValues[locale.languageCode][key];
  }

  /// Acts as the main interface to this class, all requests by other classes call this function when the need a localized value
  static String of(BuildContext context, String key) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)
        .translate(key);
  }
}
