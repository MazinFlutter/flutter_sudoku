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
      'Title': 'Sudoku',
      //Main Menu Strings
      'Continue': 'Continue',
      'NewGame': 'New Game',
      'HighScores': 'High Scores',
      'Settings': 'Settings',
      'Instructions': 'Instructions',
      'Exit': 'Exit',
      //Game Strings
      'CheckSolution' : 'Check Solution',
      'ClearAll' : 'Clear All',
      'Congratulations' : 'Congratulations !',
      'Time' : 'Time',
      //Settings Page Strings
      'Appearance': 'Appearance',
      'Color' : 'Color',
      'Game' : 'Game',
      'SettingsPageTitle' : 'Settings',
      'LanguagesAndThemes' : 'Languages and Themes',
      'Language' : 'Language',
      'Theme' : 'Theme',
      'Difficulty' : 'Difficulty',
      'Easy' : 'Easy',
      'Medium' : 'Medium',
      'Hard' : 'Hard',
      //Warning Dialog
      'UnfinishedGame' : 'Unfinished Game',
      'UnfinishedGameMessage' : 'starting a new game will delete the old one, proceed ?',
      'Cancel' : 'Cancel',
      'StartANewGame' : 'Start a New Game',
      //HighScores Page Strings
      'NoScores' : 'No Scores',
      //Instructions Page Strings
      'Previous' : 'Previous',
      'Next' : 'Next',
      'Done' : 'Done',
      'Rules': 'Rules',
      'HowToPlay' : 'How To Play',
      'Winning' : 'Winning !',
      'RulesDescription': 'Fill the board with numbers from one to nine, without repeating any numbers within columns, rows, and squares.',
      'HowToPlayDescription' : 'Tap white blocks and add numbers. \nAfter any change your answer will be checked automatically, and wrong answers will be highlighted along with conflicting numbers.',
      'WinningDescription' : 'After filling all the board correctly, the game will end, and your time will be recorded. \n\nChallenge yourself into beating your own record at different difficulty levels !',

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
      'Congratulations' : 'تهانينا !',
      'ClearAll' : 'مسح الكل',
      'CheckSolution' : 'تحقق من الحل',
      'Time' : 'الوقت',
      //Settings Page Strings
      'Appearance' : 'المظهر',
      'Color' : 'اللون',
      'Game' : 'اللعبة',
      'SettingsPageTitle' : 'الضبط',
      'LanguagesAndThemes' : 'اللغات والموضوعات',
      'Language' : 'اللغة',
      'Theme' : 'الموضوع',
      'Difficulty' : 'مستوى الصعوبة',
      'Easy' : 'سهل',
      'Medium' : 'متوسط',
      'Hard' : 'صعب',
      //Warning Dialog
      'UnfinishedGame' : 'لعبة سابقة',
      'UnfinishedGameMessage' : 'بدء لعبة جديدة سيمحو اللعبة السابقة، متابعة ؟ ',
      'Cancel' : 'الغاء',
      'StartANewGame' : 'بداية لعبة جديدة',
      //نصوص شاشة الدرجات العالية
      'NoScores' : 'لا توجد درجات',
      //نصوص شاشة التعليمات
      'Previous' : 'السابق',
      'Next' : 'التالي',
      'Done' : 'النهاية',
      'Rules': 'القواعد',
      'HowToPlay' : 'كيفية اللعب',
      'Winning' : 'الفوز !',
      'RulesDescription': 'املأ المربعات الفارغة بالأرقام من واحد إلى تسعة، بدون تكرار أي رقم داخل الصف أو العمود أو المربع.',
      'HowToPlayDescription' : 'انقر على المربعات البيضاء وأضف الأرقام، بعد كل تغيير سيتم التحقق تلقائيا واظهار الاجابات الخاطئة والأرقام المتعارضة. ',
      'WinningDescription' : ' بعد ملء اللوحة بصورة صحيحة، ستنتهي اللعبة وسيتم حفظ زمنك. '
          '\n\nتحدى نفسك وحطم أرقامك القياسية في كل مستوى.',
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
