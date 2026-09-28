import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/static_pages/controllers/static_pages_controller.dart';

import '../../../data/constants/constants.dart';

class ContactUsPage extends GetView<StaticPagesController> {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Contact Us'.tr),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UnconstrainedBox(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: Get.width * 0.5,
                    height: Get.width * 0.15,
                    fit: BoxFit.fill,
                  )
                      .decorate(padding: 18),
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    GlobalTextField(
                      hintText: 'Name'.tr,
                      inputType: TextInputType.name,
                      prefixIcon: 'person',
                      onSaved: (val) => controller.name.value = val!,
                      validator: (val) {
                        if (val == null) {
                          return 'Please enter your full name'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    GlobalTextField(
                      hintText: 'email address'.tr,
                      inputType: TextInputType.emailAddress,
                      prefixIcon: 'email',
                      onSaved: (val) => controller.email.value = val!,
                      validator: (val) {
                        if (val == null) {
                          return 'Please enter your email'.tr;
                        } else if (!val.isEmail) {
                          return 'Please enter a valid email'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    GlobalTextField(
                      contentPadding: 20,
                      hintText: 'Message'.tr,
                      inputType: TextInputType.text,
                      maxLines: 6,
                      onSaved: (val) => controller.message.value = val!,
                      validator: (val) {
                        if (val == null) {
                          return 'Message is required'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ).decorate(padding: 10),
                const SizedBox(height: 18),
                GlobalButton(
                  onTap: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.formKey.currentState!.save();
                      controller.contactUs();
                    }
                  },
                  text: 'Send'.tr,
                  width: Get.width * 0.4,
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
