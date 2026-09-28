import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/providers/shared_prefs.dart';

class AppServices extends GetxService {
  @override
  onInit() {
    super.onInit();
    getAccessToken();
    getUserId();
    getUserName();
    getUserImage();
    getUserBirthDate();
    getUserGender();
    getUserPhone();
    getNotificationOn();
    getfirsttime();
    getUserEmail();
    getUserCountry();
    getUserCurrency();
    getUserType();
  }

  /*--------------------------------------------------------------------------*/
  /*------------------------------  Variables  -------------------------------*/
  /*--------------------------------------------------------------------------*/
  Rx<OtpType> otpType = OtpType.register.obs;
  RxBool notificationsOn = RxBool(true);

  RxString notificationId = "".obs;
  Rx<UserType> userType = UserType.user.obs;

  RxInt driverId = 0.obs;
  RxString isDriverReview = ''.obs;
  RxString orderNum = ''.obs;
  RxString orderId = ''.obs;
  RxString paymentMethod = '2'.obs;
  RxString referenceNumber = ''.obs;
  RxString webViewUrl = ''.obs;

  RxString accessToken = RxString('');
  RxString userName = RxString('');
  RxString userEmail = RxString('');
  RxString userImage = RxString('');
  RxString userPhone = RxString('');
  RxString userBirthDate = RxString('');
  RxString userGender = RxString('');
  RxString userCurrencyCode = RxString('');
  RxString userCountryCode = RxString('');
  RxInt userId = RxInt(0);
  RxString? pinCode;
  RxBool isFirstTime = true.obs;

  /*--------------------------------------------------------------------------*/
  /*-------------------------  Control Toggle Bars  --------------------------*/
  /*--------------------------------------------------------------------------*/
  PageController pageController = PageController(initialPage: 0);
  RxInt currentPage = 0.obs;

  animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  pickImage(VoidCallback onCameraTap, VoidCallback onGalleryTap) async {
    Get.defaultDialog(
      title: 'Select Image'.tr,
      backgroundColor: Colors.white,
      titleStyle: Get.textTheme.titleMedium!.copyWith(
        color: Get.theme.primaryColor,
        fontWeight: FontWeight.bold,
        fontFamily: (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
      ),
      middleText: 'Select an image from your device'.tr,
      middleTextStyle: Get.textTheme.bodyMedium!.copyWith(
        color: Colors.grey,
        fontFamily: (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
      ),
      titlePadding: const EdgeInsets.all(20),
      actions: [
        TextButton(
          onPressed: onCameraTap,
          child: 'Camera'.tr.bodyMedium(color: Constants.grey),
        ),
        TextButton(
          onPressed: onGalleryTap,
          child: 'Gallery'.tr.bodyMedium(color: Constants.grey),
        ),
      ],
    );
  }

  double calculateDistance(
      {required LatLng currentLoc, required LatLng destination}) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentLoc.latitude,
      currentLoc.longitude,
      destination.latitude,
      destination.longitude,
    );

    return (distanceInMeters / 1000);
  }

  /*--------------------------------------------------------------------------*/
  /*---------------------------  Save Functions  -----------------------------*/
  /*--------------------------------------------------------------------------*/

  void setIsFirstTime(bool val) async {
    isFirstTime = val.obs;
    SharedPrefsHelper.storeisFirstTime(val);
  }

  void saveAccessToken(String token) {
    accessToken = token.obs;
    SharedPrefsHelper.saveApiKeyToPrefs(token);
  }

  void saveUserType(String val) {
    userType.value = UserType.fromJson(val);
    SharedPrefsHelper.storeUserType(val);
  }

  void saveUserName(String name) {
    userName = name.obs;
    SharedPrefsHelper.saveUserName(name);
  }

  void saveUserEmail(String email) {
    userEmail = email.obs;
    SharedPrefsHelper.saveUserEmail(email);
  }

  void saveCountryCode(String code) {
    userCountryCode = code.obs;
    SharedPrefsHelper.storeCountryCode(code);
  }

  void saveCurrencyCode(String code) {
    userCurrencyCode = code.obs;
    SharedPrefsHelper.storeCurrencyCode(code);
  }

  void saveUserImage(String image) {
    userImage = image.obs;
    SharedPrefsHelper.saveUserImg(image);
  }

  void saveUserPhone(String phone) {
    userPhone = phone.obs;
    userPhone.refresh();
    SharedPrefsHelper.saveUserPhone(phone);
  }

  void saveBirthDate(String birthDate) {
    userBirthDate = birthDate.obs;
    SharedPrefsHelper.saveUserBirthDate(birthDate);
  }

  void saveGender(String gender) {
    userGender = gender.obs;
    SharedPrefsHelper.saveGender(gender);
  }

  void saveUserId(int id) {
    userId = id.obs;
    SharedPrefsHelper.saveUserIdToPrefs(id);
  }

  void saveNotificationOn(bool status) {
    SharedPrefsHelper.saveNotificationStatus(status);
  }

  /*--------------------------------------------------------------------------*/
  /*----------------------------  Get Functions  -----------------------------*/
  /*--------------------------------------------------------------------------*/

  void getAccessToken() async {
    String? data = await SharedPrefsHelper.getApiTokenFromPrefs();
    if (data != null) {
      accessToken = data.obs;
      debugPrint('tokennnnnnnnnnnnnnnnnn :: $accessToken');
    }
  }

  void getUserType() async {
    String? data = await SharedPrefsHelper.getUserType();
    if (data != null) {
      userType.value = UserType.fromJson(data);
    }
  }

  void getUserName() async {
    String? data = await SharedPrefsHelper.getUserName();
    if (data != null) {
      userName = data.obs;
      debugPrint('Naaaaaaaaaaaaaaaaaame :: $userName');
    }
  }

  void getUserEmail() async {
    String? data = await SharedPrefsHelper.getUserEmail();
    if (data != null) {
      userEmail = data.obs;
      debugPrint('Emaaaaiiiiiiiiiiiiiiiilll :: $userEmail');
    }
  }

  void getUserCurrency() async {
    String? data = await SharedPrefsHelper.getCurrencyCode();
    if (data != null) {
      userCurrencyCode = data.obs;
      debugPrint('Imaaaaaaaaaaaaaaaaage :: $userCurrencyCode');
    }
  }

  void getUserCountry() async {
    String? data = await SharedPrefsHelper.getCountryCode();
    if (data != null) {
      userCountryCode = data.obs;
      debugPrint('Imaaaaaaaaaaaaaaaaage :: $userCountryCode');
    }
  }

  void getUserImage() async {
    String? data = await SharedPrefsHelper.getUserImg();
    if (data != null) {
      userImage = data.obs;
      debugPrint('Imaaaaaaaaaaaaaaaaage :: $userImage');
    }
  }

  void getUserPhone() async {
    String? data = await SharedPrefsHelper.getUserPhone();
    if (data != null) {
      userPhone = data.obs;
      debugPrint('Imaaaaaaaaaaaaaaaaage :: $userPhone');
    }
  }

  void getUserBirthDate() async {
    String? data = await SharedPrefsHelper.getUserBirthDate();
    if (data != null) {
      userBirthDate = data.obs;
      debugPrint('Birth Dateeeeeee :: $userBirthDate');
    }
  }

  void getUserGender() async {
    String? data = await SharedPrefsHelper.getUserGender();
    if (data != null) {
      userGender = data.obs;
      debugPrint('Birth Dateeeeeee :: $userGender');
    }
  }

  void getUserId() async {
    int? data = await SharedPrefsHelper.getUserIdFromPrefs();
    if (data != null) {
      userId = data.obs;
      debugPrint('iddddddddddddddddddddddddd :: $userId');
    }
  }

  void getNotificationOn() async {
    bool? data = await SharedPrefsHelper.getNotificationStatus();
    if (data != null) {
      notificationsOn = data.obs;
    }
  }

  void getfirsttime() async {
    bool? data = await SharedPrefsHelper.getIsFirstTime();
    if (data != null) {
      isFirstTime = data.obs;
    }
  }

  /*--------------------------------------------------------------------------*/
  /*--------------------------  Remove User Data  ----------------------------*/
  /*--------------------------------------------------------------------------*/

  void removeUserData() async {
    accessToken.value = '';
    userId.value = 0;
    userName.value = '';
    userPhone.value = '';
    userImage.value = '';
    userEmail.value = '';
    userBirthDate.value = '';
    userGender.value = '';
    SharedPrefsHelper.clear();
  }
}
