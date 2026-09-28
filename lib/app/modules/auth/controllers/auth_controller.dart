import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_phone_field.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/auth/login_response_model/login_response_model.dart';
import 'package:wayaak/app/data/models/auth/signup_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/auth/providers/auth_providers.dart';
import 'package:wayaak/app/modules/static_pages/controllers/static_pages_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthProviders authProvider = Get.find<AuthProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final StaticPagesController staticPagesController =
      Get.find<StaticPagesController>();
  RxString otpCode = ''.obs;
  Rx<DateTime> isws = DateTime.now().obs;

  RxInt userTypeVal = 0.obs;

  // ANCHOR -----> Form Keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgetPassFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPassFormKey = GlobalKey<FormState>();

  // ANCHOR -----> Text Editing Controllers
  final TextEditingController passController = TextEditingController();
  final TextEditingController passSignupController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // ANCHOR -----> Form Fields
  RxString storeName = ''.obs;
  RxString storeAddress = ''.obs;
  RxString aboutStore = ''.obs;
  RxString fullName = ''.obs;
  RxString password = ''.obs;
  RxString passConfirm = ''.obs;
  RxString phone = ''.obs;
  RxString email = ''.obs;
  RxString birthDate = ''.obs;
  RxString gender = ''.obs;

  // ANCHOR ----->  Variables
  RxBool isChecked = false.obs;
  RxBool isPassObsecure = true.obs;
  RxBool isConfirmPassObsecure = true.obs;

  // FirebaseMessaging? firebaseMessaging = FirebaseMessaging.instance;

  // ANCHOR ----->  Register Function
  register() async {
    try {
      Ui.loadingDialog();
      Get.log('beginnnnnnnnnnnnnnnnnnnnnnnnnnnn');

      Map<String, dynamic>? registerModel =
          await authProvider.postRegister(SignupRequestModel(
        name: fullName.value,
        password: password.value,
        phone: phone.value,
        email: email.value,
        birthDate: birthDate.value,
        gender: gender.value,
        language: Get.locale?.languageCode ?? 'en',
        aboutStore: aboutStore.value,
        storeAddress: storeAddress.value,
        storeName: storeName.value,
        type: userTypeVal.value == 0 ? 'user' : 'store',
      ));
      Get.log('enddddddddddddddddddddddddddddd');

      // Close loading dialog using Navigator to avoid GetX overlay issues
      try {
        if (Get.context != null && Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
      } catch (e) {
        Get.log('Error closing dialog: $e');
      }

      if (registerModel != null) {
        if (registerModel.containsKey('error')) {
          Ui.errorGetBar(
              message: 'Connection Error, Check your network please'.tr);
        } else {
          final statusCode = registerModel['code'] as int;
          if (statusCode >= 200 && statusCode < 300) {
            Ui.successGetBar(message: 'Registration completed successfully'.tr);
            Get.offAllNamed(Routes.login);
          } else {
            if (registerModel['code'] == 400 || registerModel['code'] == 403) {
              GlobalResponseModel errorModel =
                  registerModel['data'] as GlobalResponseModel;
              Ui.errorGetBar(message: errorModel.message!.tr);
            } else if (registerModel['code'] == 422) {
              Ui.errorGetBar(
                  message:
                      registerModel['data']['errors']['errors'].toString());
            } else {
              Ui.errorGetBar(message: 'Internal Server Error'.tr);
            }
          }
        }
      } else {
        Ui.errorGetBar(message: 'Internal Server Error'.tr);
      }
    } catch (e) {
      Get.log('Register error: $e');
      // Close loading dialog if still open
      try {
        if (Get.context != null && Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
      } catch (e2) {
        Get.log('Error closing dialog in catch: $e2');
      }
      Ui.errorGetBar(message: 'An unexpected error occurred'.tr);
    }
  }

  // ANCHOR ----->  Social Register Function
  socialAuth({
    String? name,
    String? email,
    String? socialMediaId,
    String? provider,
  }) async {
    Ui.loadingDialog();
    Map<String, dynamic>? registerModel = await authProvider.postSocialLogin(
      socialMediaId: socialMediaId,
      provider: provider,
    );
    if (registerModel == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      if (registerModel.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (registerModel['code'] == 200) {
          Get.back();
          LoginResponseModel loginModel =
              registerModel['data'] as LoginResponseModel;
          Ui.successGetBar(message: 'login success'.tr);
          Get.offNamedUntil(Routes.main, (route) => false)!;
          if (remember.value) {
            appServices.saveAccessToken(loginModel.data!.accessToken!);
            appServices.saveUserId(loginModel.data!.user!.id!);
            appServices.saveUserName(loginModel.data!.user!.name!);
            appServices.saveUserEmail(loginModel.data!.user!.email!);
            appServices.saveUserImage(loginModel.data!.user!.avatar ?? '');
            appServices.saveUserPhone(loginModel.data!.user!.phone!);
            appServices.saveBirthDate(loginModel.data!.user!.birthDate ?? '');
            appServices.saveGender(loginModel.data!.user!.gender ?? '');
            appServices.saveUserType(loginModel.data!.user!.type!.name);
          } else {
            appServices.accessToken.value = loginModel.data!.accessToken!;
            appServices.userName.value = loginModel.data!.user!.name!;
            appServices.userEmail.value = loginModel.data!.user!.email!;
            appServices.userImage.value = loginModel.data!.user!.avatar!;
            appServices.userPhone.value = loginModel.data!.user!.phone!;
            appServices.userId.value = loginModel.data!.user!.id!;
            appServices.userType.value = loginModel.data!.user!.type!;
            appServices.userBirthDate.value =
                loginModel.data!.user!.birthDate ?? '';
            appServices.userGender.value = loginModel.data!.user!.gender ?? '';
          }
        } else if (registerModel['code'] == 404 ||
            registerModel['code'] == 403) {
          Get.back();
          Get.generalDialog(
            transitionDuration: const Duration(milliseconds: 700),
            transitionBuilder:
                (context, animation, secondaryAnimation, child) =>
                    child.dialogTransition(animation),
            pageBuilder: (context, animation, secondaryAnimation) =>
                UnconstrainedBox(
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LayoutBuilder(builder: (context, c) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      "Enter your phone number".tr.titleSmall(),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: c.maxWidth * 0.9,
                          child: GlobalPhoneField(
                            onChanged: (val) =>
                                phone.value = val.completeNumber,
                            onSaved: (val) {
                              phone.value = val!.completeNumber;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GlobalButton(
                        onTap: () async {
                          if (phone.value.isNotEmpty) {
                            Get.back();
                            Ui.loadingDialog();
                            Map<String, dynamic>? anotherModel =
                                await authProvider.postSocialRegister(
                              socialMediaId: socialMediaId,
                              provider: provider,
                              email: email,
                              name: name,
                              phone: phone.value,
                            );
                            if (anotherModel == null) {
                              Get.back();
                              Ui.errorGetBar(
                                  message:
                                      'Error has been occured, Please try again later'
                                          .tr);
                            } else {
                              Get.back();
                              if (anotherModel['code'] == 200) {
                                // NoDataResponseModel signupModel =
                                //     anotherModel['data'] as NoDataResponseModel;
                                Get.generalDialog(
                                  transitionDuration:
                                      const Duration(milliseconds: 700),
                                  transitionBuilder: (context, animation,
                                          secondaryAnimation, child) =>
                                      child.dialogTransition(animation),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      UnconstrainedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 30),
                                        'successfully'
                                            .iconColored(size: Get.width * 0.3),
                                        const SizedBox(height: 15),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child:
                                              'Your registration was successfully, please check your phone'
                                                  .tr
                                                  .body(
                                                      color: Colors.black,
                                                      center: true),
                                        ),
                                        const SizedBox(height: 15),
                                        GlobalButton(
                                          onTap: () {
                                            Get.back();
                                            appServices.otpType.value =
                                                OtpType.register;
                                            Get.toNamed(Routes.otpCode);
                                          },
                                          text: 'Continue'.tr,
                                          width: Get.width * 0.75,
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    ).decorate(width: Get.width * 0.9),
                                  ),
                                );
                              } else if (anotherModel['code'] == 400 ||
                                  anotherModel['code'] == 403) {
                                Ui.errorGetBar(
                                    message: anotherModel['data']
                                        .message
                                        .toString()
                                        .tr);
                              } else {
                                Ui.errorGetBar(
                                    message:
                                        'Error has been occured, Please try again later'
                                            .tr);
                              }
                            }
                          }
                        },
                        text: 'Signup',
                        width: Get.width * 0.75,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ).decorate(width: Get.width * 0.9);
                }),
              ),
            ),
          );
        } else if (registerModel['code'] == 400 ||
            registerModel['code'] == 403 ||
            registerModel['code'] == 401) {
          Get.back();
          Ui.errorGetBar(message: registerModel['data'].message.toString().tr);
        } else {
          Get.back();
          Ui.errorGetBar(
              message: 'Error has been occured, Please try again later'.tr);
        }
      }
    }
  }

// ANCHOR ----->  Login Function
  RxBool remember = false.obs;
  RxBool terms = false.obs;
  login() async {
    try {
      Ui.loadingDialog();

      await FirebaseMessaging.instance.requestPermission();
      String? fcmToken;
      try {
        await FirebaseMessaging.instance.getAPNSToken();
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        Get.log("FCM Token Error: $e");
      }
      Map<String, dynamic>? data =
          await authProvider.postLogin(phone.value, password.value, fcmToken);
      Get.log("Device Token :: $fcmToken -- ${data}");

      // Close loading dialog using Navigator to avoid GetX overlay issues
      try {
        if (Get.context != null && Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
      } catch (e) {
        Get.log('Error closing dialog: $e');
      }

      if (data == null) {
        Ui.errorGetBar(message: 'Internal Server Error'.tr);
      } else {
        if (data.containsKey('error')) {
          Ui.errorGetBar(
              message: 'Connection Error, Check your network please'.tr);
        } else {
          if (data['code'] == 200) {
            LoginResponseModel loginModel = data['data'] as LoginResponseModel;
            // Ui.successGetBar(message: 'login success'.tr);
            if (remember.value) {
              appServices.saveAccessToken(loginModel.data!.accessToken!);
              appServices.saveUserId(loginModel.data!.user!.id!);
              appServices.saveUserName(loginModel.data!.user!.name!);
              appServices.saveUserEmail(loginModel.data!.user!.email!);
              appServices.saveUserPhone(loginModel.data!.user!.phone!);
              appServices.saveUserImage(loginModel.data!.user!.avatar ?? '');
              appServices.saveBirthDate(loginModel.data!.user!.birthDate ?? '');
              appServices.saveGender(loginModel.data!.user!.gender ?? '');
              appServices.saveUserType(loginModel.data!.user!.type!.name);
            } else {
              appServices.accessToken.value = loginModel.data!.accessToken!;
              appServices.userName.value = loginModel.data!.user!.name!;
              appServices.userEmail.value = loginModel.data!.user!.email!;
              appServices.userImage.value = loginModel.data!.user!.avatar!;
              appServices.userPhone.value = loginModel.data!.user!.phone!;
              appServices.userId.value = loginModel.data!.user!.id!;
              appServices.userType.value = loginModel.data!.user!.type!;
              appServices.userBirthDate.value =
                  loginModel.data!.user!.birthDate ?? '';
              appServices.userGender.value =
                  loginModel.data!.user!.gender ?? '';
            }
            // Navigate after successful login
            Get.offNamedUntil(Routes.main, (route) => false);
          } else if (data['code'] == 403) {
            // Add delay before showing dialog
            await Future.delayed(const Duration(milliseconds: 100));
            Get.generalDialog(
              barrierDismissible: true,
              barrierLabel: 'verify your phone',
              transitionDuration: const Duration(milliseconds: 700),
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      child.dialogTransition(animation),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  UnconstrainedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    'verify your phone'.tr.titleSmall(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: 'please verify your phone to be able to login'
                          .tr
                          .bodyMedium(center: true),
                    ),
                    const SizedBox(height: 20),
                    GlobalButton(
                      onTap: () async {
                        await resendOtp();
                        Get.back();
                        Get.toNamed(Routes.otpCode);
                      },
                      text: 'Verify'.tr,
                      width: Get.width * 0.75,
                    ),
                    const SizedBox(height: 30),
                  ],
                ).decorate(width: Get.width * 0.9),
              ),
            );
          } else if (data['code'] == 400 || data['code'] == 401) {
            Ui.errorGetBar(message: data['data'].message.toString().tr);
          } else {
            Ui.errorGetBar(
                message: 'Error has been occured, Please try again later'.tr);
          }
        }
      }
    } catch (e) {
      Get.log('Login error: $e');
      // Close loading dialog if still open
      try {
        if (Get.context != null && Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
      } catch (e2) {
        Get.log('Error closing dialog in catch: $e2');
      }
      Ui.errorGetBar(message: 'An unexpected error occurred'.tr);
    }
  }

// ANCHOR ----->  Verify OTP Function
  verifyOtp() async {
    try {
      Ui.loadingDialog();
      Map<String, dynamic>? data =
          await authProvider.postVerify(phone.value, otpCode.value);

      // Close loading dialog using Navigator to avoid GetX overlay issues
      try {
        if (Get.context != null && Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
      } catch (e) {
        Get.log('Error closing dialog: $e');
      }

      if (data == null) {
        Ui.errorGetBar(message: 'Internal Server Error'.tr);
      } else {
        if (data.containsKey('error')) {
          Ui.errorGetBar(
              message: 'Connection Error, Check your network please'.tr);
        } else {
          if (data['code'] == 200) {
            LoginResponseModel loginModel = data['data'] as LoginResponseModel;
            Ui.successGetBar(message: 'login success'.tr);
            log("phoooooooooooooooooooooooooooooooone :: ${loginModel.data!.user!.phone!}");
            appServices.saveAccessToken(loginModel.data!.accessToken!);
            appServices.saveUserId(loginModel.data!.user!.id!);
            appServices.saveUserName(loginModel.data!.user!.name!);
            appServices.saveUserEmail(loginModel.data!.user!.email!);
            appServices.saveUserImage(loginModel.data!.user!.avatar ?? '');
            appServices.saveUserPhone(loginModel.data!.user!.phone!);
            appServices.saveBirthDate(loginModel.data!.user!.birthDate ?? '');
            appServices.saveGender(loginModel.data!.user!.gender ?? '');
            appServices.saveUserType(loginModel.data!.user!.type!.name);

            log("phoooooooooooooooooooooooooooooooone 2222 :: ${appServices.userPhone.value}");
            // Navigate after successful OTP verification
            Get.offNamedUntil(Routes.main, (route) => false);
          } else if (data['code'] == 400) {
            Ui.errorGetBar(message: data['data'].message.toString().tr);
          } else {
            Ui.errorGetBar(
                message: 'Error has been occured, Please try again later'.tr);
          }
        }
      }
    } catch (e) {
      Get.log('Verify OTP error: $e');
      // Close loading dialog if still open
      try {
        if (Get.context != null && Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
      } catch (e2) {
        Get.log('Error closing dialog in catch: $e2');
      }
      Ui.errorGetBar(message: 'An unexpected error occurred'.tr);
    }
  }

// ANCHOR ----->  Forget Password Function
  forgetPassword() async {
    Ui.loadingDialog();
    NoDataResponseModel? data = await authProvider
        .getForgetPassword(phone.value.replaceAll('+', '%2B'));
    if (data == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      if (data.status != 200) {
        Get.back();
        Ui.errorGetBar(message: data.message!.tr);
      } else {
        Get.back();
        appServices.otpType.value = OtpType.forgetPass;
        Get.toNamed(Routes.otpCode);
        Ui.successGetBar(message: 'code has been sent to your phone'.tr);
      }
    }
  }

  RxInt remainingTime = 60.obs;
  Timer? timer;
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
      }
    });
  }
  // 30.0781 , 31.2773 --> salama afify
  // 30.0039 , 31.2161 --> warshet elnegara
  // arley.jeron@filesaved.org  -- 1618171925

// ANCHOR ----->  Forget Password Function
  resendOtp() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await authProvider.postResendOtp(phone.value);
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] != 200) {
          Get.back();
          Ui.errorGetBar(message: 'invalid phone number'.tr);
        } else {
          Get.back();
          appServices.otpType.value = OtpType.verifyPhone;
          Ui.successGetBar(
              message: (data['data'] as NoDataResponseModel).message!.tr);
          remainingTime.value = 60;
          startTimer();
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

// ANCHOR ----->  Forget Password Function
  resetCode() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await authProvider.postCheckResetCode(phone.value, otpCode.value);
    if (data == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Ui.successGetBar(message: 'code is success'.tr);
          Get.toNamed(Routes.resetPass);
        } else {
          Ui.errorGetBar(
              message: 'Error has been occured, Please try again later'.tr);
        }
      }
    }
  }

// ANCHOR ----->  Forget Password Function
  resetPassword() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await authProvider.postResetPassword(
        phone.value, password.value, passConfirm.value);
    if (data == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Ui.successGetBar(message: 'password changed successfully'.tr);
          Get.offAllNamed(Routes.login);
        } else {
          Ui.errorGetBar(
              message: 'Error has been occured, Please try again later'.tr);
        }
      }
    }
  }
}
