import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  static const String baseUrl = 'https://wyaak.com/';
  // static const String baseUrl = 'https://wayaak.dev2.tqnia.me/';

  static const Color primary = Color(0xFF1C8B9B);
  static const Color secondary = Color(0xFF231F20);
  static const Color accent = Color(0xFFEF2525);
  static const Color green = Color(0xFF5FD788);
  static const Color grey = Color(0xFFA7AEC1);
  static const Color softGrey = Color(0xFFF5F5F5);
  static const Color hintText = Color(0xFFAAB0C3);
  static const Color textColor = Color(0xFF858494);
}

Future<void> launch(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
