import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/balance_model/balance_model.dart';
import 'package:wayaak/app/data/models/charge_wallet_model/charge_wallet_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/profile_model/profile_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';
import 'package:wayaak/app/modules/profile/providers/profile_providers.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ProfileProviders provider = Get.find<ProfileProviders>();
  final HomeController homeController = Get.find<HomeController>();
  final OrdersController ordersController = Get.find<OrdersController>();
  final AppServices appServices = Get.find<AppServices>();

  Rx<DateTime> isws = DateTime.now().obs;

  RxBool isProfileLoading = false.obs;
  Rx<ProfileModel> profileModel = ProfileModel().obs;

  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController walletController = TextEditingController();
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editEmailController = TextEditingController();
  final TextEditingController editPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> walletFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePassFormKey = GlobalKey<FormState>();

  // ANCHOR -----> Form Fields
  RxString fullName = ''.obs;
  RxString email = ''.obs;
  RxString oldPassword = ''.obs;
  RxString password = ''.obs;
  RxString passConfirm = ''.obs;
  RxString birthDate = ''.obs;
  RxString gender = ''.obs;
  Rx<File> avatar = File('').obs;
  RxBool isOldPassObsecure = true.obs;
  RxBool isPassObsecure = true.obs;
  RxBool isConfirmPassObsecure = true.obs;

  updateProfileData() async {
    Ui.loadingDialog();
    if (email.value.isEmpty) {
      email.value = appServices.userEmail.value;
    }

    Map<String, dynamic>? data = await provider.postUpdateProfile(
      name: fullName.value,
      email: email.value.isEmpty ? appServices.userEmail.value : email.value,
      birthDate: birthDate.value,
      avatar: avatar.value,
      gender: gender.value,
    );

    if (data != null) {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.back();
          profileModel.value = data['data'] as ProfileModel;
          Ui.successGetBar(message: profileModel.value.message!);
          appServices.saveUserName(profileModel.value.data!.user!.name!);
          appServices.saveUserEmail(profileModel.value.data!.user!.email!);
          appServices
              .saveUserImage(profileModel.value.data!.user!.avatar ?? '');
          appServices.saveUserPhone(profileModel.value.data!.user!.phone!);
          appServices
              .saveBirthDate(profileModel.value.data!.user!.birthDate ?? '');
          appServices.saveGender(profileModel.value.data!.user!.gender ?? '');
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'error occured on updating profile data');
    }
  }

  chargeWallet() async {
    Ui.loadingDialog();

    Map<String, dynamic>? data = await provider.postChargeWallet(
      50.0,
      appServices.referenceNumber.value,
    );

    if (data != null) {

      log("dataa ${data}");
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Ui.successGetBar(
              message:
                  "Your Balance: ${(data['data'] as ChargeWalletModel).data!.balance!}");
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'error occured on charging wallet');
    }
  }

  getProfileData() async {
    isProfileLoading.value = true;
    Map<String, dynamic>? data = await provider.getProfile();

    if (data != null) {
      isProfileLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          profileModel.value = data['data'] as ProfileModel;
        } else {
          Ui.errorGetBar(message: 'error occured on getting profile data');
        }
      }
    } else {
      isProfileLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting profile data');
    }
  }

  RxBool isBalanceLoading = false.obs;
  Rx<BalanceModel> balanceModel = BalanceModel().obs;
  getAccountBalance() async {
    isBalanceLoading.value = true;
    Map<String, dynamic>? data = await provider.getAccountBalance();
    if (data != null) {
      isBalanceLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          balanceModel.value = data['data'] as BalanceModel;
        } else {
          Ui.errorGetBar(message: 'error occured on getting account balance');
        }
      }
    } else {
      isBalanceLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting account balance');
    }
  }

  handlingChargeWallet({required double totalPrice}) async {
    const paymentUrl = 'https://wyaak.com/api/charge_wallet_kashier';

    // var bytes1 = utf8.encode(
    //     "SOfCOPay_8mWnXndPARLg12${appServices.userId.value}https://www.google.com6b5fdea340e31b3b0339d4d4ae51${totalPrice.toStringAsFixed(2)}${totalPrice.toStringAsFixed(2)}256a0b10-d7e3-4592-9a27-ae17f76b54ad_SOfCOPay");
    // var digest1 = sha256.convert(bytes1);
    // Get.log("SHA256 :: $digest1");
    // Map<String, dynamic> data = {
    //   "merchantId": 3,
    //   "merchantCode": "8mWnXndPARLg",
    //   "referenceNumber": 12,
    //   "customer": {
    //     "id": "${appServices.userId.value}",
    //     "name": appServices.userName.value,
    //     "email": appServices.userEmail.value,
    //     "phone": appServices.userPhone.value
    //   },
    //   "expiryDate": "11-12-2025",
    //   "items": [
    //     {
    //       "type": "ChargeRequest",
    //       "id": "6b5fdea340e31b3b0339d4d4ae5",
    //       "description": "Product Description",
    //       "price": totalPrice,
    //       "quantity": 1.00,
    //       "imageUrl": "https://developer.fawrystaging.com/photos/45566.jpg",
    //       "total": totalPrice
    //     }
    //   ],
    //   "total": totalPrice,
    //   "shippingAddress": null,
    //   "paymentMethod": null,
    //   "status": 0,
    //   "returnUrl": "https://www.google.com",
    //   "signature": "$digest1",
    //   "paymentURL": "",
    //   "statusCode": "",
    //   "statusDescription": "",
    //   "pgwRefNum": "",
    //   "id": null,
    //   "createdDate": "2024-07-20T10:51:36.908424Z",
    //   "lastUpdatedDate": "2024-07-20T10:51:36.908466Z",
    //   "createdBy": "system",
    //   "lastCreatedBy": "system",
    //   "isActive": true
    // };

    try {
      Ui.loadingDialog();
      var response = await Dio().post(paymentUrl,
          data: {
            "balance": totalPrice,
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${Get.find<AppServices>().accessToken.value}',
          }));
      Get.log("Response :: ${response.data}");
      Get.back();
      walletController.text = '';
      if (response.statusCode == 200) {
        // appServices.referenceNumber.value =
        //     (jsonDecode(response.data))['referenceNumber'];
        print('***************************');
        print(response.data['data']['paymentUrl']);
        appServices.webViewUrl.value = response.data['data']['paymentUrl'];

        Get.back();
        await Get.toNamed(Routes.checkout, arguments: 'Wallet');

        Ui.successGetBar(message: 'Refresh your screen for new updates.'.tr);
        // isBalanceLoading.value = true;
        // Future.delayed(const Duration(seconds: 5)).then((_){
        //   getAccountBalance();
        // });
      }
    } on DioException catch (e) {
      Get.log("Dio Exception :: ${e.message}");
      Get.log("Dio Exception :: ${e.error}");
      Get.log("Dio Exception :: ${e.response!.statusCode!}");
    }
  }

// ANCHOR ----->  Forget Password Function
  resetPassword() async {
    Ui.loadingDialog();
    Get.log("Phooooooooooooone :: ${appServices.userPhone.value}");
    Map<String, dynamic>? data = await provider.postUpdatePassword(
        oldPassword.value, password.value, password.value);
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
          Get.back();
          Ui.successGetBar(message: 'password changed successfully'.tr);
        } else {
          Ui.errorGetBar(
              message: (data['data'] as GlobalResponseModel).message!);
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    getProfileData();
    getAccountBalance();
  }

  @override
  void onClose() {
    walletController.dispose();
    birthDateController.dispose();
    editPassController.dispose();
    super.onClose();
  }
}
