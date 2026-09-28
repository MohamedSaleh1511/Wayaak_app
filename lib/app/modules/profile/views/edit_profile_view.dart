import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/profile/controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Edit Profile'.tr),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    ImagePicker picker = ImagePicker();
                    controller.appServices.pickImage(
                      () async {
                        final imageSelected = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 50,
                        );
                        if (imageSelected != null) {
                          controller.avatar.value = File(imageSelected.path);
                        }
                        Get.back();
                      },
                      () async {
                        final imageSelected = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                        );
                        if (imageSelected != null) {
                          controller.avatar.value = File(imageSelected.path);
                        }
                        Get.back();
                      },
                    );
                  },
                  child: controller.avatar.value.path.isEmpty
                      ? SizedBox(
                          width: Get.width * 0.5,
                          height: Get.width * 0.5,
                          child: Image.asset('assets/images/edit profile.png'),
                        )
                      : Container(
                          width: Get.width * 0.5,
                          height: Get.width * 0.5,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.file(
                            controller.avatar.value,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      GlobalTextField(
                        controller: controller.editNameController,
                        hintText: 'full name'.tr,
                        prefixIcon: 'person',
                        inputType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => controller.fullName.value = val!,
                      ),
                      const SizedBox(height: 8),
                      GlobalTextField(
                        controller: controller.editEmailController,
                        hintText: 'email address'.tr,
                        prefixIcon: 'email',
                        inputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => controller.email.value = val!,
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Please enter your email'.tr;
                          } else if (!val.isEmail) {
                            return 'Please enter a valid email'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      GlobalTextField(
                        controller: controller.birthDateController,
                        hintText: 'Birth Date'.tr,
                        prefixIcon: 'calender',
                        inputType: TextInputType.datetime,
                        onTap: () async {
                          DateTime? result = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now()
                                .subtract(const Duration(days: 366)),
                            currentDate: controller.isws.value,
                          );

                          if (result != null &&
                              result != controller.isws.value) {
                            controller.isws.value = result;
                          }

                          controller.birthDateController.text =
                              DateFormat('yyyy-MM-dd').format(result!);
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => controller.birthDate.value = val!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          controller.gender.value = 'male';
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: (controller.gender.value == 'male')
                                ? Border.all(
                                    color: Get.theme.primaryColor, width: 1.5)
                                : Border.all(color: Constants.grey, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              'male'.iconColored(
                                  color: (controller.gender.value == 'male')
                                      ? Get.theme.primaryColor
                                      : Constants.grey),
                              const SizedBox(width: 5),
                              "Male".tr.button(
                                  color: (controller.gender.value == 'male')
                                      ? Get.theme.primaryColor
                                      : Constants.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          controller.gender.value = 'female';
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: (controller.gender.value == 'female')
                                ? Border.all(
                                    color: Get.theme.primaryColor, width: 1.5)
                                : Border.all(color: Constants.grey, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              'female'.iconColored(
                                  color: (controller.gender.value == 'female')
                                      ? Get.theme.primaryColor
                                      : Constants.grey),
                              const SizedBox(width: 5),
                              "Female".tr.button(
                                  color: (controller.gender.value == 'female')
                                      ? Get.theme.primaryColor
                                      : Constants.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                GlobalButton(
                  onTap: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.formKey.currentState!.save();
                      controller.updateProfileData();
                    }
                  },
                  text: 'Save'.tr,
                  width: Get.width,
                  height: 55,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
