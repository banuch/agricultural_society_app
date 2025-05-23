import 'package:flutter/material.dart';

class SimpleLocalizations {
  final Locale locale;

  SimpleLocalizations(this.locale);

  static SimpleLocalizations of(BuildContext context) {
    return Localizations.of<SimpleLocalizations>(context, SimpleLocalizations) ??
        SimpleLocalizations(const Locale('en', ''));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Agricultural Society',
      'welcome': 'Welcome',
      'login': 'Login',
      'sign_up': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'name': 'Full Name',
      'phone_number': 'Phone Number',
      'location': 'Location',
      'profile': 'Profile',
      'save': 'Save',
      'cancel': 'Cancel',
      'loading': 'Loading...',
      'buyer': 'Buyer',
      'seller': 'Seller',
      'both': 'Both Buyer & Seller',
      'get_current_location': 'Get Current Location',
      'validate_pincode': 'Validate Pincode',
      'pincode': 'Pincode',
      'current_location': 'Current Location',
      'continue_with_google': 'Continue with Google',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      'forgot_password': 'Forgot Password?',
      'personal_info': 'Personal Information',
      'role_selection': 'Role Selection',
      'location_info': 'Location Information',
      'update_profile': 'Update Profile',
      'profile_status': 'Profile Status',
      'quick_actions': 'Quick Actions',
      'marketplace': 'Marketplace',
      'community': 'Community',
      'location_settings': 'Location Settings',
      'feature_coming_soon': 'Feature coming soon!',
      'profile_updated_successfully': 'Profile updated successfully!',
      'location_retrieved_successfully': 'Location retrieved successfully!',
      'pincode_validated_successfully': 'Pincode validated successfully!',
      'invalid_pincode': 'Invalid pincode',
      'please_enter_name': 'Please enter your name',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'password_too_short': 'Password must be at least 6 characters',
      'please_enter_phone_number': 'Please enter your phone number',
      'please_enter_valid_phone_number': 'Please enter a valid phone number',
      'please_enter_pincode': 'Please enter your pincode',
      'please_enter_valid_pincode': 'Please enter a valid 6-digit pincode',
    },
    'hi': {
      'app_name': 'कृषि समाज',
      'welcome': 'स्वागत',
      'login': 'लॉगिन',
      'sign_up': 'साइन अप',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'name': 'पूरा नाम',
      'phone_number': 'फ़ोन नंबर',
      'location': 'स्थान',
      'profile': 'प्रोफ़ाइल',
      'save': 'सेव करें',
      'cancel': 'रद्द करें',
      'loading': 'लोड हो रहा है...',
      'buyer': 'खरीदार',
      'seller': 'विक्रेता',
      'both': 'खरीदार और विक्रेता दोनों',
      'get_current_location': 'वर्तमान स्थान प्राप्त करें',
      'validate_pincode': 'पिनकोड सत्यापित करें',
      'pincode': 'पिनकोड',
      'current_location': 'वर्तमान स्थान',
      'continue_with_google': 'Google के साथ जारी रखें',
      'dont_have_account': 'खाता नहीं है?',
      'already_have_account': 'पहले से खाता है?',
      'forgot_password': 'पासवर्ड भूल गए?',
      'personal_info': 'व्यक्तिगत जानकारी',
      'role_selection': 'भूमिका चयन',
      'location_info': 'स्थान की जानकारी',
      'update_profile': 'प्रोफ़ाइल अपडेट करें',
      'profile_status': 'प्रोफ़ाइल स्थिति',
      'quick_actions': 'त्वरित कार्य',
      'marketplace': 'बाज़ार',
      'community': 'समुदाय',
      'location_settings': 'स्थान सेटिंग्स',
      'feature_coming_soon': 'फीचर जल्द आ रहा है!',
      'profile_updated_successfully': 'प्रोफ़ाइल सफलतापूर्वक अपडेट हो गया!',
      'location_retrieved_successfully': 'स्थान सफलतापूर्वक प्राप्त हुआ!',
      'pincode_validated_successfully': 'पिनकोड सफलतापूर्वक सत्यापित हुआ!',
      'invalid_pincode': 'गलत पिनकोड',
      'please_enter_name': 'कृपया अपना नाम दर्ज करें',
      'please_enter_email': 'कृपया अपना ईमेल दर्ज करें',
      'please_enter_valid_email': 'कृपया एक वैध ईमेल दर्ज करें',
      'please_enter_password': 'कृपया अपना पासवर्ड दर्ज करें',
      'password_too_short': 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए',
      'please_enter_phone_number': 'कृपया अपना फ़ोन नंबर दर्ज करें',
      'please_enter_valid_phone_number': 'कृपया एक वैध फ़ोन नंबर दर्ज करें',
      'please_enter_pincode': 'कृपया अपना पिनकोड दर्ज करें',
      'please_enter_valid_pincode': 'कृपया एक वैध 6-अंकीय पिनकोड दर्ज करें',
    },
    'te': {
      'app_name': 'వ్యవసాయ సంఘం',
      'welcome': 'స్వాగతం',
      'login': 'లాగిన్',
      'sign_up': 'సైన్ అప్',
      'email': 'ఇమెయిల్',
      'password': 'పాస్వర్డ్',
      'name': 'పూర్తి పేరు',
      'phone_number': 'ఫోన్ నంబర్',
      'location': 'స్థానం',
      'profile': 'ప్రొఫైల్',
      'save': 'సేవ్ చేయండి',
      'cancel': 'రద్దు చేయండి',
      'loading': 'లోడ్ అవుతోంది...',
      'buyer': 'కొనుగోలుదారు',
      'seller': 'అమ్మకందారు',
      'both': 'కొనుగోలుదారు మరియు అమ్మకందారు రెండూ',
      'get_current_location': 'ప్రస్తుత స్థానం పొందండి',
      'validate_pincode': 'పిన్కోడ్ను ధృవీకరించండి',
      'pincode': 'పిన్కోడ్',
      'current_location': 'ప్రస్తుత స్థానం',
      'continue_with_google': 'Google తో కొనసాగించండి',
      'dont_have_account': 'ఖాతా లేదా?',
      'already_have_account': 'ఇప్పటికే ఖాతా ఉందా?',
      'forgot_password': 'పాస్వర్డ్ మర్చిపోయారా?',
      'personal_info': 'వ్యక్తిగత సమాచారం',
      'role_selection': 'పాత్ర ఎంపిక',
      'location_info': 'స్థాన సమాచారం',
      'update_profile': 'ప్రొఫైల్ అప్డేట్ చేయండి',
      'profile_status': 'ప్రొఫైల్ స్థితి',
      'quick_actions': 'త్వరిత చర్యలు',
      'marketplace': 'మార్కెట్ప్లేస్',
      'community': 'కమ్యూనిటీ',
      'location_settings': 'స్థాన సెట్టింగ్లు',
      'feature_coming_soon': 'ఫీచర్ త్వరలో వస్తోంది!',
      'profile_updated_successfully': 'ప్రొఫైల్ విజయవంతంగా అప్డేట్ చేయబడింది!',
      'location_retrieved_successfully': 'స్థానం విజయవంతంగా పొందబడింది!',
      'pincode_validated_successfully': 'పిన్కోడ్ విజయవంతంగా ధృవీకరించబడింది!',
      'invalid_pincode': 'చెల్లని పిన్కోడ్',
      'please_enter_name': 'దయచేసి మీ పేరు నమోదు చేయండి',
      'please_enter_email': 'దయచేసి మీ ఇమెయిల్ నమోదు చేయండి',
      'please_enter_valid_email': 'దయచేసి చెల్లుబాటు అయ్యే ఇమెయిల్ నమోదు చేయండి',
      'please_enter_password': 'దయచేసి మీ పాస్వర్డ్ నమోదు చేయండి',
      'password_too_short': 'పాస్వర్డ్ కనీసం 6 అక్షరాలు ఉండాలి',
      'please_enter_phone_number': 'దయచేసి మీ ఫోన్ నంబర్ నమోదు చేయండి',
      'please_enter_valid_phone_number': 'దయచేసి చెల్లుబాటు అయ్యే ఫోన్ నంబర్ నమోదు చేయండి',
      'please_enter_pincode': 'దయచేసి మీ పిన్కోడ్ నమోదు చేయండి',
      'please_enter_valid_pincode': 'దయచేసి చెల్లుబాటు అయ్యే 6-అంకెల పిన్కోడ్ నమోదు చేయండి',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Getters for common translations
  String get appName => get('app_name');
  String get welcome => get('welcome');
  String get login => get('login');
  String get signUp => get('sign_up');
  String get email => get('email');
  String get password => get('password');
  String get name => get('name');
  String get phoneNumber => get('phone_number');
  String get location => get('location');
  String get profile => get('profile');
  String get save => get('save');
  String get cancel => get('cancel');
  String get loading => get('loading');
  String get buyer => get('buyer');
  String get seller => get('seller');
  String get both => get('both');
  String get getCurrentLocation => get('get_current_location');
  String get validatePincode => get('validate_pincode');
  String get pincode => get('pincode');
  String get currentLocation => get('current_location');
  String get continueWithGoogle => get('continue_with_google');
  String get dontHaveAccount => get('dont_have_account');
  String get alreadyHaveAccount => get('already_have_account');
  String get forgotPassword => get('forgot_password');
  String get personalInfo => get('personal_info');
  String get roleSelection => get('role_selection');
  String get locationInfo => get('location_info');
  String get updateProfile => get('update_profile');
  String get profileStatus => get('profile_status');
  String get quickActions => get('quick_actions');
  String get marketplace => get('marketplace');
  String get community => get('community');
  String get locationSettings => get('location_settings');
  String get featureComingSoon => get('feature_coming_soon');
  String get profileUpdatedSuccessfully => get('profile_updated_successfully');
  String get locationRetrievedSuccessfully => get('location_retrieved_successfully');
  String get pincodeValidatedSuccessfully => get('pincode_validated_successfully');
  String get invalidPincode => get('invalid_pincode');
  String get pleaseEnterName => get('please_enter_name');
  String get pleaseEnterEmail => get('please_enter_email');
  String get pleaseEnterValidEmail => get('please_enter_valid_email');
  String get pleaseEnterPassword => get('please_enter_password');
  String get passwordTooShort => get('password_too_short');
  String get pleaseEnterPhoneNumber => get('please_enter_phone_number');
  String get pleaseEnterValidPhoneNumber => get('please_enter_valid_phone_number');
  String get pleaseEnterPincode => get('please_enter_pincode');
  String get pleaseEnterValidPincode => get('please_enter_valid_pincode');

  static const LocalizationsDelegate<SimpleLocalizations> delegate = _SimpleLocalizationsDelegate();
}

class _SimpleLocalizationsDelegate extends LocalizationsDelegate<SimpleLocalizations> {
  const _SimpleLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'te'].contains(locale.languageCode);
  }

  @override
  Future<SimpleLocalizations> load(Locale locale) async {
    return SimpleLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<SimpleLocalizations> old) => false;
}