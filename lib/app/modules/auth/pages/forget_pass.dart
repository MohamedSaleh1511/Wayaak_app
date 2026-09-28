import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/back_button.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_phone_field.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import '../controllers/auth_controller.dart';

class ForgetPassPage extends GetView<AuthController> {
  const ForgetPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          height: Get.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                const GlobalBackButton(),
                const SizedBox(height: 26),
                'Forget password?'.tr.headline(color: Colors.black),
                const SizedBox(height: 5),
                'enter your phone number to receive code'.tr.body(),
                const SizedBox(height: 40),
                Form(
                  key: controller.forgetPassFormKey,
                  child: Column(
                    children: [
                      GlobalPhoneField(
                        onChanged: (phone) {},
                        onSaved: (val) {
                          controller.phone.value = val!.completeNumber;
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GlobalButton(
                  onTap: () {
                    if (controller.forgetPassFormKey.currentState!.validate()) {
                      controller.forgetPassFormKey.currentState!.save();
                      controller.forgetPassword();
                    }
                  },
                  text: 'Continue'.tr,
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
