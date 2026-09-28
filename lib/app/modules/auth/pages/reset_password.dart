import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/back_button.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/auth/controllers/auth_controller.dart';

class ResetPassword extends GetView<AuthController> {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: Get.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                const GlobalBackButton(),
                const SizedBox(height: 26),
                'Reset password'.tr.headline(color: Colors.black),
                const SizedBox(height: 5),
                'enter a new password'.tr.body(),
                const SizedBox(height: 40),
                Obx(() {
                  return Form(
                    key: controller.resetPassFormKey,
                    child: Column(
                      children: [
                        GlobalTextField(
                          hintText: 'New Password'.tr,
                          prefixIcon: 'lock',
                          suffixIcon: (controller.isPassObsecure.value)
                              ? 'eye-closed'
                              : 'eye',
                          obsecure: controller.isPassObsecure.value,
                          inputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          onSaved: (val) => controller.password.value = val!,
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return 'password is required'.tr;
                            } else if (val.length < 8) {
                              return 'password must be at least 8 digits'.tr;
                            } else {
                              return null;
                            }
                          },
                          onSuffixTap: () => controller.isPassObsecure.value =
                              !controller.isPassObsecure.value,
                        ),
                        const SizedBox(height: 8),
                        GlobalTextField(
                          hintText: 'Re-type New Password'.tr,
                          prefixIcon: 'lock',
                          obsecure: controller.isConfirmPassObsecure.value,
                          suffixIcon: (controller.isConfirmPassObsecure.value)
                              ? 'eye-closed'
                              : 'eye',
                          inputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          onSaved: (val) => controller.passConfirm.value = val!,
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return 'password is required'.tr;
                            } else if (val.length < 8) {
                              return 'password must be at least 8 digits'.tr;
                            } else {
                              return null;
                            }
                          },
                          onSuffixTap: () => controller.isConfirmPassObsecure
                              .value = !controller.isConfirmPassObsecure.value,
                        ),
                      ],
                    ),
                  );
                }),
                const Spacer(),
                GlobalButton(
                  onTap: () {
                    if (controller.resetPassFormKey.currentState!.validate()) {
                      controller.resetPassFormKey.currentState!.save();
                      controller.resetPassword();
                    }
                  },
                  text: 'Save'.tr,
                  width: Get.width,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
