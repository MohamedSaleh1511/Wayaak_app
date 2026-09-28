import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//   const double earthRadiusKm = 6371.0; // Radius of the Earth in kilometers

//   // Convert degrees to radians
//   double dLat = _degreesToRadians(lat2 - lat1);
//   double dLon = _degreesToRadians(lon2 - lon1);

//   // Haversine formula
//   double a = sin(dLat / 2) * sin(dLat / 2) +
//       cos(_degreesToRadians(lat1)) *
//           cos(_degreesToRadians(lat2)) *
//           sin(dLon / 2) *
//           sin(dLon / 2);

//   double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//   return earthRadiusKm * c;
// }

double calculateDistance(
    {required LatLng currentLoc, required LatLng destination}) {
  double distanceInMeters = Geolocator.distanceBetween(
    currentLoc.latitude,
    currentLoc.longitude,
    destination.latitude,
    destination.longitude,
  );

  return distanceInMeters / 1000;
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

dynamic haversineDistance(LatLng player1, LatLng player2) {
  double lat1 = player1.latitude;
  double lon1 = player1.longitude;
  double lat2 = player2.latitude;
  double lon2 = player2.longitude;

  var R = 6371e3; // metres
  // var R = 1000;
  var phi1 = (lat1 * pi) / 180; // φ, λ in radians
  var phi2 = (lat2 * pi) / 180;
  var deltaPhi = ((lat2 - lat1) * pi) / 180;
  var deltaLambda = ((lon2 - lon1) * pi) / 180;

  var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
      cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

  var c = 2 * atan2(sqrt(a), sqrt(1 - a));

  var d = R * c; // in metres

  return d;
}

// // Helper function to convert degrees to radians
// double _degreesToRadians(double degrees) {
//   return degrees * pi / 180.0;
// }

Future<void> launch(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty input but prevent invalid numbers like 0 or negative numbers
    if (text.isEmpty) {
      return newValue;
    }

    // Convert input to number and check if greater than 0
    final number = int.tryParse(text);
    if (number != null && number > 0) {
      return newValue;
    }

    // If invalid (like negative or zero), return the old value
    return oldValue;
  }
}

// Map of ISO country codes to ISO currency codes
const Map<String, String> countryCurrencyMap = {
  'AD': 'EUR', // Andorra
  'AE': 'AED', // United Arab Emirates
  'AF': 'AFN', // Afghanistan
  'AG': 'XCD', // Antigua and Barbuda
  'AI': 'XCD', // Anguilla
  'AL': 'ALL', // Albania
  'AM': 'AMD', // Armenia
  'AO': 'AOA', // Angola
  'AR': 'ARS', // Argentina
  'AS': 'USD', // American Samoa
  'AT': 'EUR', // Austria
  'AU': 'AUD', // Australia
  'AW': 'AWG', // Aruba
  'AX': 'EUR', // Åland Islands
  'AZ': 'AZN', // Azerbaijan
  'BA': 'BAM', // Bosnia and Herzegovina
  'BB': 'BBD', // Barbados
  'BD': 'BDT', // Bangladesh
  'BE': 'EUR', // Belgium
  'BF': 'XOF', // Burkina Faso
  'BG': 'BGN', // Bulgaria
  'BH': 'BHD', // Bahrain
  'BI': 'BIF', // Burundi
  'BJ': 'XOF', // Benin
  'BL': 'EUR', // Saint Barthélemy
  'BM': 'BMD', // Bermuda
  'BN': 'BND', // Brunei Darussalam
  'BO': 'BOB', // Bolivia
  'BQ': 'USD', // Bonaire, Sint Eustatius, and Saba
  'BR': 'BRL', // Brazil
  'BS': 'BSD', // Bahamas
  'BT': 'BTN', // Bhutan
  'BV': 'NOK', // Bouvet Island
  'BW': 'BWP', // Botswana
  'BY': 'BYN', // Belarus
  'BZ': 'BZD', // Belize
  'CA': 'CAD', // Canada
  'CC': 'AUD', // Cocos (Keeling) Islands
  'CD': 'CDF', // Congo (DRC)
  'CF': 'XAF', // Central African Republic
  'CG': 'XAF', // Congo (Republic)
  'CH': 'CHF', // Switzerland
  'CI': 'XOF', // Côte d'Ivoire
  'CK': 'NZD', // Cook Islands
  'CL': 'CLP', // Chile
  'CM': 'XAF', // Cameroon
  'CN': 'CNY', // China
  'CO': 'COP', // Colombia
  'CR': 'CRC', // Costa Rica
  'CU': 'CUP', // Cuba
  'CV': 'CVE', // Cape Verde
  'CW': 'ANG', // Curaçao
  'CX': 'AUD', // Christmas Island
  'CY': 'EUR', // Cyprus
  'CZ': 'CZK', // Czech Republic
  'DE': 'EUR', // Germany
  'DJ': 'DJF', // Djibouti
  'DK': 'DKK', // Denmark
  'DM': 'XCD', // Dominica
  'DO': 'DOP', // Dominican Republic
  'DZ': 'DZD', // Algeria
  'EC': 'USD', // Ecuador
  'EE': 'EUR', // Estonia
  'EG': 'EGP', // Egypt
  'EH': 'MAD', // Western Sahara
  'ER': 'ERN', // Eritrea
  'ES': 'EUR', // Spain
  'ET': 'ETB', // Ethiopia
  'FI': 'EUR', // Finland
  'FJ': 'FJD', // Fiji
  'FM': 'USD', // Micronesia
  'FO': 'DKK', // Faroe Islands
  'FR': 'EUR', // France
  'GA': 'XAF', // Gabon
  'GB': 'GBP', // United Kingdom
  'GD': 'XCD', // Grenada
  'GE': 'GEL', // Georgia
  'GF': 'EUR', // French Guiana
  'GG': 'GBP', // Guernsey
  'GH': 'GHS', // Ghana
  'GI': 'GIP', // Gibraltar
  'GL': 'DKK', // Greenland
  'GM': 'GMD', // Gambia
  'GN': 'GNF', // Guinea
  'GP': 'EUR', // Guadeloupe
  'GQ': 'XAF', // Equatorial Guinea
  'GR': 'EUR', // Greece
  'GT': 'GTQ', // Guatemala
  'GU': 'USD', // Guam
  'GW': 'XOF', // Guinea-Bissau
  'GY': 'GYD', // Guyana
  'HK': 'HKD', // Hong Kong
  'HN': 'HNL', // Honduras
  'HR': 'HRK', // Croatia
  'HT': 'HTG', // Haiti
  'HU': 'HUF', // Hungary
  'ID': 'IDR', // Indonesia
  'IE': 'EUR', // Ireland
  'IL': 'ILS', // Israel
  'IM': 'GBP', // Isle of Man
  'IN': 'INR', // India
  'IO': 'USD', // British Indian Ocean Territory
  'IQ': 'IQD', // Iraq
  'IR': 'IRR', // Iran
  'IS': 'ISK', // Iceland
  'IT': 'EUR', // Italy
  'JE': 'GBP', // Jersey
  'JM': 'JMD', // Jamaica
  'JO': 'JOD', // Jordan
  'JP': 'JPY', // Japan
  'KE': 'KES', // Kenya
  'KG': 'KGS', // Kyrgyzstan
  'KH': 'KHR', // Cambodia
  'KI': 'AUD', // Kiribati
  'KM': 'KMF', // Comoros
  'KN': 'XCD', // Saint Kitts and Nevis
  'KP': 'KPW', // North Korea
  'KR': 'KRW', // South Korea
  'KW': 'KWD', // Kuwait
  'KY': 'KYD', // Cayman Islands
  'KZ': 'KZT', // Kazakhstan
  'LA': 'LAK', // Laos
  'LB': 'LBP', // Lebanon
  'LC': 'XCD', // Saint Lucia
  'LI': 'CHF', // Liechtenstein
  'LK': 'LKR', // Sri Lanka
  'LR': 'LRD', // Liberia
  'LS': 'LSL', // Lesotho
  'LT': 'EUR', // Lithuania
  'LU': 'EUR', // Luxembourg
  'LV': 'EUR', // Latvia
  'LY': 'LYD', // Libya
  'MA': 'MAD', // Morocco
  'MC': 'EUR', // Monaco
  'MD': 'MDL', // Moldova
  'ME': 'EUR', // Montenegro
  'MF': 'EUR', // Saint Martin
  'MG': 'MGA', // Madagascar
  'MH': 'USD', // Marshall Islands
  'MK': 'MKD', // North Macedonia
  'ML': 'XOF', // Mali
  'MM': 'MMK', // Myanmar
  'MN': 'MNT', // Mongolia
  'MO': 'MOP', // Macao
  'MP': 'USD', // Northern Mariana Islands
  'MQ': 'EUR', // Martinique
  'MR': 'MRU', // Mauritania
  'MS': 'XCD', // Montserrat
  'MT': 'EUR', // Malta
  'MU': 'MUR', // Mauritius
  'MV': 'MVR', // Maldives
  'MW': 'MWK', // Malawi
  'MX': 'MXN', // Mexico
  'MY': 'MYR', // Malaysia
  'MZ': 'MZN', // Mozambique
  'NA': 'NAD', // Namibia
  'NC': 'XPF', // New Caledonia
  'NE': 'XOF', // Niger
  'NF': 'AUD', // Norfolk Island
  'NG': 'NGN', // Nigeria
  'NI': 'NIO', // Nicaragua
  'NL': 'EUR', // Netherlands
  'NO': 'NOK', // Norway
  'NP': 'NPR', // Nepal
  'NR': 'AUD', // Nauru
  'NU': 'NZD', // Niue
  'NZ': 'NZD', // New Zealand
  'OM': 'OMR', // Oman
  'PA': 'PAB', // Panama
  'PE': 'PEN', // Peru
  'PF': 'XPF', // French Polynesia
  'PG': 'PGK', // Papua New Guinea
  'PH': 'PHP', // Philippines
  'PK': 'PKR', // Pakistan
  'PL': 'PLN', // Poland
  'PM': 'EUR', // Saint Pierre and Miquelon
  'PN': 'NZD', // Pitcairn
  'PR': 'USD', // Puerto Rico
  'PT': 'EUR', // Portugal
  'PW': 'USD', // Palau
  'PY': 'PYG', // Paraguay
  'QA': 'QAR', // Qatar
  'RE': 'EUR', // Réunion
  'RO': 'RON', // Romania
  'RS': 'RSD', // Serbia
  'RU': 'RUB', // Russia
  'RW': 'RWF', // Rwanda
  'SA': 'SAR', // Saudi Arabia
  'SB': 'SBD', // Solomon Islands
  'SC': 'SCR', // Seychelles
  'SD': 'SDG', // Sudan
  'SE': 'SEK', // Sweden
  'SG': 'SGD', // Singapore
  'SH': 'SHP', // Saint Helena
  'SI': 'EUR', // Slovenia
  'SJ': 'NOK', // Svalbard and Jan Mayen
  'SK': 'EUR', // Slovakia
  'SL': 'SLL', // Sierra Leone
  'SM': 'EUR', // San Marino
  'SN': 'XOF', // Senegal
  'SO': 'SOS', // Somalia
  'SR': 'SRD', // Suriname
  'SS': 'SSP', // South Sudan
  'ST': 'STN', // Sao Tome and Principe
  'SV': 'SVC', // El Salvador
  'SX': 'ANG', // Sint Maarten
  'SY': 'SYP', // Syria
  'SZ': 'SZL', // Eswatini
  'TC': 'USD', // Turks and Caicos Islands
  'TD': 'XAF', // Chad
  'TF': 'EUR', // French Southern Territories
  'TG': 'XOF', // Togo
  'TH': 'THB', // Thailand
  'TJ': 'TJS', // Tajikistan
  'TK': 'NZD', // Tokelau
  'TL': 'USD', // Timor-Leste
  'TM': 'TMT', // Turkmenistan
  'TN': 'TND', // Tunisia
  'TO': 'TOP', // Tonga
  'TR': 'TRY', // Turkey
  'TT': 'TTD', // Trinidad and Tobago
  'TV': 'AUD', // Tuvalu
  'TW': 'TWD', // Taiwan
  'TZ': 'TZS', // Tanzania
  'UA': 'UAH', // Ukraine
  'UG': 'UGX', // Uganda
  'UM': 'USD', // United States Minor Outlying Islands
  'US': 'USD', // United States
  'UY': 'UYU', // Uruguay
  'UZ': 'UZS', // Uzbekistan
  'VA': 'EUR', // Vatican City
  'VC': 'XCD', // Saint Vincent and the Grenadines
  'VE': 'VES', // Venezuela
  'VG': 'USD', // British Virgin Islands
  'VI': 'USD', // U.S. Virgin Islands
  'VN': 'VND', // Vietnam
  'VU': 'VUV', // Vanuatu
  'WF': 'XPF', // Wallis and Futuna
  'WS': 'WST', // Samoa
  'YE': 'YER', // Yemen
  'YT': 'EUR', // Mayotte
  'ZA': 'ZAR', // South Africa
  'ZM': 'ZMW', // Zambia
  'ZW': 'ZWL', // Zimbabwe
};

String? getCurrencyCode(String countryCode) {
  return countryCurrencyMap[countryCode];
}

bool isValidEmail(String email) {
  final emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  return emailRegex.hasMatch(email);
}

class WordSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove existing separators and spaces
    final rawText = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();

    for (int i = 0; i < rawText.length; i++) {
      buffer.write(rawText[i]);
      // Add '-' after every character except the last one
      if (i < 3 && i != rawText.length - 1) {
        buffer.write('-');
      }
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
