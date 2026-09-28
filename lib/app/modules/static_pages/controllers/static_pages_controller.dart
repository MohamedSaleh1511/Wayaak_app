import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/contact_us_model/contact_us_model.dart';
import 'package:wayaak/app/data/models/static_pages_model/static_pages_model.dart';
import 'package:wayaak/app/modules/static_pages/providers/static_pages_provider.dart';

class StaticPagesController extends GetxController {
  final StaticPagesProviders provider = Get.find<StaticPagesProviders>();

  RxBool loading = false.obs;
  Rx<StaticPagesModel> privacyModel = StaticPagesModel().obs;
  Rx<StaticPagesModel> termsModel = StaticPagesModel().obs;
  Rx<StaticPagesModel> aboutModel = StaticPagesModel().obs;

  getPrivacyPolicy() async {
    loading.value = true;
    final response = await provider.getPrivacyPolicy();
    if (response != null) {
      loading.value = false;
      if (response.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (response['code'] == 200) {
          privacyModel.value = response['data'] as StaticPagesModel;
        } else {
          Ui.errorGetBar(message: 'Error occured on getting privacy policy');
        }
      }
    } else {
      loading.value = false;
      Ui.errorGetBar(message: 'Error occured on getting privacy policy');
    }
  }

  getTerms() async {
    loading.value = true;
    final response = await provider.getTermsAndConditions();
    if (response != null) {
      loading.value = false;
      if (response.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (response['code'] == 200) {
          termsModel.value = response['data'] as StaticPagesModel;
        } else {
          Ui.errorGetBar(message: 'Error occured on getting terms');
        }
      }
    } else {
      loading.value = false;
      Ui.errorGetBar(message: 'Error occured on getting terms');
    }
  }

  getAbout() async {
    loading.value = true;
    final response = await provider.getAboutUs();
    if (response != null) {
      loading.value = false;
      if (response.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (response['code'] == 200) {
          aboutModel.value = response['data'] as StaticPagesModel;
        } else {
          Ui.errorGetBar(message: 'Error occured on getting about');
        }
      }
    } else {
      loading.value = false;
      Ui.errorGetBar(message: 'Error occured on getting about');
    }
  }

  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString message = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  contactUs() async {
    Ui.loadingDialog();
    final response = await provider.contactUs(
      name: name.value,
      email: email.value,
      message: message.value,
    );
    if (response != null) {
      Get.back();
      if (response.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (response['code'] == 200) {
          Get.back();
          Ui.successGetBar(
              message: (response['data'] as ContactUsModel).message!);
        } else {
          Ui.errorGetBar(message: 'Error occured on contacting us');
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'Error occured on contacting us');
    }
  }
}
