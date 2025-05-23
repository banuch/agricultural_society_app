import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<bool> load() async {
    try {
      String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      return true;
    } catch (e) {
      // If language file not found, load English as fallback
      try {
        String jsonString = await rootBundle.loadString('assets/lang/en.json');
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
        return true;
      } catch (e) {
        // If even English fails, use empty map
        _localizedStrings = {};
        return false;
      }
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Common translations with fallbacks
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get signUp => translate('sign_up');
  String get email => translate('email');
  String get password => translate('password');
  String get name => translate('name');
  String get phoneNumber => translate('phone_number');
  String get location => translate('location');
  String get profile => translate('profile');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get error => translate('error');
  String get success => translate('success');
  String get loading => translate('loading');
  String get retry => translate('retry');

  // User roles
  String get buyer => translate('buyer');
  String get seller => translate('seller');
  String get both => translate('both');

  // Location related
  String get getCurrentLocation => translate('get_current_location');
  String get validatePincode => translate('validate_pincode');
  String get pincode => translate('pincode');
  String get currentLocation => translate('current_location');

  // Authentication
  String get continueWithGoogle => translate('continue_with_google');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get forgotPassword => translate('forgot_password');

  // Profile
  String get personalInfo => translate('personal_info');
  String get roleSelection => translate('role_selection');
  String get locationInfo => translate('location_info');
  String get updateProfile => translate('update_profile');
  String get profileStatus => translate('profile_status');

  // Home screen
  String get quickActions => translate('quick_actions');
  String get marketplace => translate('marketplace');
  String get community => translate('community');
  String get locationSettings => translate('location_settings');

  // Messages
  String get featureComingSoon => translate('feature_coming_soon');
  String get profileUpdatedSuccessfully => translate('profile_updated_successfully');
  String get locationRetrievedSuccessfully => translate('location_retrieved_successfully');
  String get pincodeValidatedSuccessfully => translate('pincode_validated_successfully');
  String get invalidPincode => translate('invalid_pincode');

  // Validation messages
  String get pleaseEnterName => translate('please_enter_name');
  String get pleaseEnterEmail => translate('please_enter_email');
  String get pleaseEnterValidEmail => translate('please_enter_valid_email');
  String get pleaseEnterPassword => translate('please_enter_password');
  String get passwordTooShort => translate('password_too_short');
  String get pleaseEnterPhoneNumber => translate('please_enter_phone_number');
  String get pleaseEnterValidPhoneNumber => translate('please_enter_valid_phone_number');
  String get pleaseEnterPincode => translate('please_enter_pincode');
  String get pleaseEnterValidPincode => translate('please_enter_valid_pincode');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'te'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;

  @override
  Type get type => AppLocalizations;
}