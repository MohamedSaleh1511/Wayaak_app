import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';

class TitleDescPart extends GetWidget<AddOrderController> {
  const TitleDescPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.addOrderFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          'Order Description'.tr.subtitle(),
          const SizedBox(height: 6),
          GlobalTextField(
            controller: controller.descriptionController,
            hintText: 'orderDescription'.tr,
            noBorder: true,
            maxLines: 4,
            suffixIcon: 'upload',
            suffixColor: Colors.black,
            onSuffixTap: () async {
              FocusScope.of(context).unfocus();
              ImagePicker picker = ImagePicker();
              controller.appServices.pickImage(
                () async {
                  final imageSelected = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.rear,
                  );
                  if (imageSelected != null) {
                    controller.productImages.add(File(imageSelected.path));
                  }
                  Get.back();
                },
                () async {
                  List<XFile> images = await picker.pickMultiImage(
                    imageQuality: 60,
                  );
                  if (images.isNotEmpty) {
                    controller.productImages
                        .addAll(images.map((e) => File(e.path)).toList());
                  }
                  Get.back();
                },
              );
            },
            validator: (v) {
              if (v!.isEmpty) {
                return "Please enter your order description".tr;
              } else {
                return null;
              }
            },
          ).decorate(),
          const SizedBox(height: 10),
          // Image thumbnails display
          Obx(() {
            if (controller.productImages.isEmpty) {
              return const SizedBox();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.productImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                controller.productImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 5,
                              child: GestureDetector(
                                onTap: () {
                                  controller.productImages.removeAt(index);
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: 'trash'.iconColored(
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }
}
