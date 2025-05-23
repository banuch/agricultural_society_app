import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', '');

  Locale get currentLocale => _currentLocale;

  // Supported languages
  static const List<Map<String, dynamic>> supportedLanguages = [
    {
      'locale': Locale('en', ''),
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
    },
    {
      'locale': Locale('hi', ''),
      'name': 'Hindi',
      'nativeName': 'हिंदी',
      'flag': '🇮🇳',
    },
    {
      'locale': Locale('te', ''),
      'name': 'Telugu',
      'nativeName': 'తెలుగు',
      'flag': '🇮🇳',
    },
  ];

  LanguageProvider() {
    _loadLanguage();
  }

  // Load saved language preference
  void _loadLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String languageCode = prefs.getString('language_code') ?? 'en';
      _currentLocale = Locale(languageCode, '');
      notifyListeners();
    } catch (e) {
      // If there's an error loading preferences, default to English
      _currentLocale = const Locale('en', '');
      notifyListeners();
    }
  }

  // Change language and save preference
  Future<void> changeLanguage(Locale locale) async {
    try {
      _currentLocale = locale;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', locale.languageCode);
      notifyListeners();
    } catch (e) {
      // Handle error silently, keep current language
      debugPrint('Error saving language preference: $e');
    }
  }

  // Get language display name
  String getLanguageName(Locale locale, {bool native = false}) {
    final language = supportedLanguages.firstWhere(
          (lang) => lang['locale'] == locale,
      orElse: () => supportedLanguages.first,
    );
    return native ? language['nativeName'] : language['name'];
  }

  // Get language flag emoji
  String getLanguageFlag(Locale locale) {
    final language = supportedLanguages.firstWhere(
          (lang) => lang['locale'] == locale,
      orElse: () => supportedLanguages.first,
    );
    return language['flag'];
  }

  // Check if locale is supported
  bool isLocaleSupported(Locale locale) {
    return supportedLanguages.any((lang) => lang['locale'] == locale);
  }

  // Get current language display info
  Map<String, dynamic> getCurrentLanguageInfo() {
    return supportedLanguages.firstWhere(
          (lang) => lang['locale'] == _currentLocale,
      orElse: () => supportedLanguages.first,
    );
  }

  // Reset to default language
  Future<void> resetToDefault() async {
    await changeLanguage(const Locale('en', ''));
  }
}