import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/support/controllers/support_controller.dart';

class AddTicketView extends GetView<SupportController> {
  const AddTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add Ticket'.tr.titleSmall(color: Colors.black),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            controller.file.value = File('');
            if (Get.isSnackbarOpen) {
              Get.closeCurrentSnackbar();
            }
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
            Get.back();
          },
          icon: Transform.flip(
            flipX: Get.locale == const Locale('ar'),
            child: 'Arrow Back'.iconColored(),
          ),
        ),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  UnconstrainedBox(
                    child: 'logo'
                        .iconColored(size: Get.width * 0.18)
                        .decorate(padding: 18),
                  ),
                  const SizedBox(height: 20),
                  GlobalTextField(
                    hintText: "Subject".tr,
                    inputType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onSaved: (val) => controller.subject.value = val!,
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'Subject is required'.tr;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  GlobalTextField(
                    hintText: "Message".tr,
                    inputType: TextInputType.text,
                    maxLines: 8,
                    textInputAction: TextInputAction.next,
                    onSaved: (val) => controller.message.value = val!,
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'Message is required'.tr;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () {
                      return (controller.file.value.path.isEmpty)
                          ? Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: 1.5, color: Get.theme.primaryColor),
                              ),
                              child: GlobalButton(
                                onTap: () {
                                  ImagePicker picker = ImagePicker();
                                  controller.appServices.pickImage(
                                    () async {
                                      final imageSelected =
                                          await picker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 50,
                                      );
                                      if (imageSelected != null) {
                                        controller.file.value =
                                            File(imageSelected.path);
                                      }
                                      Get.back();
                                    },
                                    () async {
                                      final imageSelected =
                                          await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50,
                                      );
                                      if (imageSelected != null) {
                                        controller.file.value =
                                            File(imageSelected.path);
                                      }
                                      Get.back();
                                    },
                                  );
                                },
                                text: 'Add File'.tr,
                                icon: 'upload',
                                textColor: Get.theme.primaryColor,
                                color: Colors.transparent,
                              ),
                            ).decorate(padding: 8)
                          : InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Get.generalDialog(
                                  transitionBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    Tween<Offset> tween;
                                    if (animation.status ==
                                        AnimationStatus.reverse) {
                                      tween = Tween(
                                          begin: const Offset(0, 1),
                                          end: Offset.zero);
                                    } else {
                                      tween = Tween(
                                          begin: const Offset(0, 1),
                                          end: Offset.zero);
                                    }

                                    return SlideTransition(
                                      position: tween.animate(CurvedAnimation(
                                          parent: animation,
                                          curve:
                                              Curves.fastEaseInToSlowEaseOut)),
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 600),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      InteractiveViewer(
                                    child: Image.file(controller.file.value),
                                  ),
                                  barrierColor: Colors.black,
                                  barrierDismissible: true,
                                  barrierLabel: 'image preview',
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Get.theme.colorScheme.secondary,
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image.file(
                                      File(controller.file.value.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.file.value.path
                                            .split('/')
                                            .last
                                            .bodyMedium(
                                                color: Colors.black,
                                                maxLines: 2),
                                      ],
                                    ),
                                  ),
                                  IconButton.filled(
                                    onPressed: () {
                                      controller.file.value = File('');
                                    },
                                    icon: 'trash'
                                        .iconColored(color: Colors.white),
                                    style: IconButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Constants.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ).decorate(padding: 8, radius: 10);
                    },
                  ),
                  const SizedBox(height: 25),
                  GlobalButton(
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.formKey.currentState!.save();
                        controller.createTicket();
                      }
                    },
                    text: "Add".tr,
                    width: Get.width * 0.5,
                    height: 55,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
