import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:wayaak/app/data/providers/shared_prefs.dart';

class TranslationService extends GetxService {
  final translations = <String, Map<String, String>>{}.obs;
  // fallbackLocale saves the day when the locale gets in trouble
  final fallbackLocale = const Locale('en', 'US');

  // must add language codes here
  static final languages = [
    'en_US',
    'ar',
  ];

  @override
  onInit() {
    super.onInit();
    getLocale();
  }

  Future<TranslationService> init() async {
    for (var lang in languages) {
      var file = await Helper.getJsonFile('assets/locales/$lang.json');
      translations.putIfAbsent(lang, () => Map<String, String>.from(file));
    }
    return this;
  }

  // get list of supported local in the application
  List<Locale> supportedLocales() {
    return TranslationService.languages.map((locale) {
      return fromStringToLocale(locale);
    }).toList();
  }

  // Convert string code to local object
  Locale fromStringToLocale(String locale) {
    if (locale.contains('_')) {
      // en_US
      return Locale(
          locale.split('_').elementAt(0), locale.split('_').elementAt(1));
    } else {
      // en
      return Locale(locale);
    }
  }

  getLocale() async {
    String? locale = await SharedPrefsHelper.getLanguage();
    if (locale != null) {
      Get.updateLocale(Locale(locale));
    }
  }
}

class Helper {
  static Future<dynamic> getJsonFile(String path) async {
    return rootBundle.loadString(path).then(convert.jsonDecode);
  }

  static Future<dynamic> getFilesInDirectory(String path) async {
    var files = io.Directory(path).listSync();
    Get.printInfo(info: files.toString());
    // return rootBundle.(path).then(convert.jsonDecode);
  }
}
