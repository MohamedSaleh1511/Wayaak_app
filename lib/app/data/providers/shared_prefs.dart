import 'package:shared_preferences/shared_preferences.dart';
// import 'constants.dart';

class SharedPrefsHelper {
  static SharedPreferences? prefs;

/*----------------------------------------------------------------------------*/
/*----------------------------  Initialize Prefs  ----------------------------*/
/*----------------------------------------------------------------------------*/
  static initPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  static clear() async {
    await initPrefs();
    prefs!.clear();
  }

/*----------------------------------------------------------------------------*/
/*------------------------------  Access Token  ------------------------------*/
/*----------------------------------------------------------------------------*/
  static void saveApiKeyToPrefs(accessToken) async {
    await initPrefs();
    prefs!.setString('accessToken', accessToken);
  }

  static Future<String?> getApiTokenFromPrefs() async {
    await initPrefs();
    String? accessTokenSaved = prefs!.getString('accessToken');
    return accessTokenSaved;
  }

/*----------------------------------------------------------------------------*/
/*---------------------------------  User Id  --------------------------------*/
/*----------------------------------------------------------------------------*/
  static void saveUserIdToPrefs(userid) async {
    await initPrefs();
    prefs!.setInt('userId', userid);
  }

  static Future<int?> getUserIdFromPrefs() async {
    await initPrefs();
    int? userIdSaved = prefs!.getInt('userId');
    return userIdSaved;
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  Language  --------------------------------*/
/*----------------------------------------------------------------------------*/
  static storeLanguage(String language) async {
    await initPrefs();
    await prefs!.setString('lang', language);
  }

  static Future<String?> getLanguage() async {
    await initPrefs();
    return prefs?.getString('lang');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  User Type  -------------------------------*/
/*----------------------------------------------------------------------------*/
  static saveUserName(String name) async {
    await initPrefs();
    await prefs!.setString('userName', name);
  }

  static Future<String?> getUserName() async {
    await initPrefs();
    return prefs!.getString('userName');
  }

  static saveUserEmail(String name) async {
    await initPrefs();
    await prefs!.setString('userEmail', name);
  }

  static Future<String?> getUserEmail() async {
    await initPrefs();
    return prefs!.getString('userEmail');
  }

  static saveUserImg(String img) async {
    await initPrefs();
    await prefs!.setString('userImg', img);
  }

  static Future<String?> getUserImg() async {
    await initPrefs();
    return prefs!.getString('userImg');
  }

  static Future<String?> getUserBirthDate() async {
    await initPrefs();
    return prefs!.getString('userBirthDate');
  }

  static Future<String?> getUserGender() async {
    await initPrefs();
    return prefs!.getString('userGender');
  }

  static saveNotificationStatus(bool status) async {
    await initPrefs();
    await prefs!.setBool('notificationStatus', status);
  }

  static Future<bool?> getNotificationStatus() async {
    await initPrefs();
    return prefs!.getBool('notificationStatus');
  }

  static saveUserPhone(String phone) async {
    await initPrefs();
    await prefs!.setString('userPhone', phone);
  }

  static saveUserBirthDate(String birthDate) async {
    await initPrefs();
    await prefs!.setString('userBirthDate', birthDate);
  }

  static saveGender(String gender) async {
    await initPrefs();
    await prefs!.setString('userGender', gender);
  }

  static Future<String?> getUserPhone() async {
    await initPrefs();
    return prefs!.getString('userPhone');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  Country  ---------------------------------*/
/*----------------------------------------------------------------------------*/
  static storeCountryCode(String code) async {
    await initPrefs();
    await prefs!.setString('country', code);
  }

  static Future<String?> getCountryCode() async {
    await initPrefs();
    return prefs?.getString('country');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  Currency  ---------------------------------*/
/*----------------------------------------------------------------------------*/
  static storeCurrencyCode(String code) async {
    await initPrefs();
    await prefs!.setString('currency', code);
  }

  static Future<String?> getCurrencyCode() async {
    await initPrefs();
    return prefs?.getString('currency');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  First time  --------------------------------*/
/*----------------------------------------------------------------------------*/
  static void storeisFirstTime(bool isFirstTime) async {
    await initPrefs();
    prefs!.setBool('isFirstTime', isFirstTime);
  }

  static Future<bool?> getIsFirstTime() async {
    await initPrefs();
    bool? isFirstTimeSaved = prefs!.getBool('isFirstTime');
    return isFirstTimeSaved;
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  First time  --------------------------------*/
/*----------------------------------------------------------------------------*/
  static void storeUserType(String val) async {
    await initPrefs();
    prefs!.setString('userType', val);
  }

  static Future<String?> getUserType() async {
    await initPrefs();
    String? val = prefs!.getString('userType');
    return val;
  }
}
