import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/core/widgets/back_button.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_phone_field.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class SignupPage extends GetView<AuthController> {
  const SignupPage({super.key});

  Future<void> _selectBirthYear(BuildContext context) async {
    final now = DateTime.now();
    final initialYear = controller.birthDateController.text.isEmpty
        ? now.year - 18
        : int.tryParse(controller.birthDateController.text) ?? now.year - 18;

    final selectedYear = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose birth year'.tr, textAlign: TextAlign.center),
        content: SizedBox(
          width: 300,
          height: 280,
          child: YearPicker(
            firstDate: DateTime(1950),
            lastDate: now,
            selectedDate: DateTime(initialYear),
            currentDate: DateTime(initialYear),
            onChanged: (date) => Navigator.of(context).pop(date.year),
          ),
        ),
      ),
    );

    if (selectedYear != null) {
      controller.birthDateController.text = selectedYear.toString();
      controller.birthDate.value = '$selectedYear-01-01';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          physics: const BouncingScrollPhysics(),
          child: Obx(
            () {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const GlobalBackButton(),
                        Expanded(
                          child: 'Final step'.tr.bodyMedium(
                                center: true,
                                color: Constants.grey,
                              ),
                        ),
                        const SizedBox(width: 44),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const CircleAvatar(
                            radius: 46,
                            backgroundColor: Color(0xffeef1f6),
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                          ),
                          PositionedDirectional(
                            start: -2,
                            bottom: 2,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.add,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Form(
                      key: controller.signupFormKey,
                      child: Column(
                        children: [
                          GlobalTextField(
                            hintText: 'full name'.tr,
                            prefixIcon: 'person',
                            inputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) => controller.fullName.value = val!,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Please enter your full name'.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          GlobalTextField(
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
                          const SizedBox(height: 10),
                          GlobalTextField(
                            controller: controller.birthDateController,
                            hintText: 'Birth year'.tr,
                            prefixIcon: 'calender',
                            inputType: TextInputType.number,
                            onTap: () => _selectBirthYear(context),
                            onSaved: (_) {},
                            validator: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'Birth date is required'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          GlobalPhoneField(
                            onChanged: (phone) {},
                            onSaved: (val) {
                              controller.phone.value = val!.completeNumber;
                            },
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () {
                              return GlobalTextField(
                                controller: controller.passSignupController,
                                obsecure: controller.isPassObsecure.value,
                                hintText: 'password'.tr,
                                prefixIcon: 'lock',
                                suffixIcon: (controller.isPassObsecure.value)
                                    ? 'eye-closed'
                                    : 'eye',
                                inputType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.next,
                                onSaved: (val) =>
                                    controller.password.value = val!,
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'password is required'.tr;
                                  } else if (val.length < 8) {
                                    return 'password must be at least 8 digits'
                                        .tr;
                                  } else {
                                    return null;
                                  }
                                },
                                onSuffixTap: () => controller.isPassObsecure
                                    .value = !controller.isPassObsecure.value,
                              );
                            },
                          ),
                          Obx(
                            () {
                              if (controller.userTypeVal.value == 1) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    GlobalTextField(
                                      hintText: 'store name'.tr,
                                      prefixIcon: 'storeline',
                                      inputType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      onSaved: (val) =>
                                          controller.storeName.value = val!,
                                      validator: (String? val) {
                                        if (val!.isEmpty &&
                                            controller.userTypeVal.value == 1) {
                                          return 'Please enter your store name'
                                              .tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    GlobalTextField(
                                      hintText: 'store address'.tr,
                                      prefixIcon: 'location',
                                      inputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onSaved: (val) =>
                                          controller.storeAddress.value = val!,
                                      validator: (String? val) {
                                        if (val!.isEmpty &&
                                            controller.userTypeVal.value == 1) {
                                          return 'Please enter your stores address'
                                              .tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    GlobalTextField(
                                      hintText: 'about store'.tr,
                                      prefixIcon: 'info',
                                      inputType: TextInputType.text,
                                      textInputAction: TextInputAction.go,
                                      onSaved: (val) =>
                                          controller.aboutStore.value = val!,
                                      validator: (String? val) {
                                        if (val!.isEmpty &&
                                            controller.userTypeVal.value == 1) {
                                          return 'Please enter description about store'
                                              .tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    'Gender'.tr.bodyMedium(color: Constants.grey),
                    const SizedBox(height: 8),
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
                                color: (controller.gender.value == 'male')
                                    ? Get.theme.primaryColor
                                    : Colors.white,
                                border: (controller.gender.value == 'male')
                                    ? Border.all(
                                        color: Get.theme.primaryColor,
                                        width: 1.5)
                                    : Border.all(
                                        color: Constants.grey, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  'male'.iconColored(
                                      color: (controller.gender.value == 'male')
                                          ? Colors.white
                                          : Constants.grey),
                                  const SizedBox(width: 5),
                                  "Male".tr.button(
                                      color: (controller.gender.value == 'male')
                                          ? Colors.white
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
                                color: (controller.gender.value == 'female')
                                    ? Get.theme.primaryColor
                                    : Colors.white,
                                border: (controller.gender.value == 'female')
                                    ? Border.all(
                                        color: Get.theme.primaryColor,
                                        width: 1.5)
                                    : Border.all(
                                        color: Constants.grey, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  'female'.iconColored(
                                      color:
                                          (controller.gender.value == 'female')
                                              ? Colors.white
                                              : Constants.grey),
                                  const SizedBox(width: 5),
                                  "Female".tr.button(
                                      color:
                                          (controller.gender.value == 'female')
                                              ? Colors.white
                                              : Constants.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () {
                        return Row(
                          children: [
                            Checkbox(
                              value: controller.terms.value,
                              onChanged: (val) {
                                controller.terms.value = val!;
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Wrap(
                                runSpacing: 3,
                                spacing: 3,
                                children: [
                                  'I Agree to our '
                                      .tr
                                      .caption(color: Colors.black),
                                  GestureDetector(
                                    onTap: () {
                                      controller.staticPagesController
                                          .getTerms();
                                      Get.toNamed(Routes.terms);
                                    },
                                    child: 'Terms of Services'.tr.caption(
                                          color: Get.theme.primaryColor,
                                          weight: FontWeight.w600,
                                        ),
                                  ),
                                  ' and '.tr.caption(color: Colors.black),
                                  GestureDetector(
                                    onTap: () {
                                      controller.staticPagesController
                                          .getPrivacyPolicy();
                                      Get.toNamed(Routes.privacy);
                                    },
                                    child: 'Privacy Policy'.tr.caption(
                                          color: Get.theme.primaryColor,
                                          weight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    GlobalButton(
                      onTap: () {
                        if (controller.signupFormKey.currentState!.validate()) {
                          controller.signupFormKey.currentState!.save();
                          if (!controller.terms.value) {
                            Ui.errorGetBar(
                                message:
                                    'Please agree to our terms & policy'.tr);
                          } else {
                            controller.register();
                          }
                        }
                      },
                      text: 'Continue'.tr,
                      width: Get.width,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        'Already have an account? '.tr.bodyMedium(),
                        ' '.tr.bodyMedium(),
                        GestureDetector(
                          onTap: () => Get.offNamed(Routes.login),
                          child: 'sign in'.tr.bodyMedium(
                                color: Get.theme.primaryColor,
                                weight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
