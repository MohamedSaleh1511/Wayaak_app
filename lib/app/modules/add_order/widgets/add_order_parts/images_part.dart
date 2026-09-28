import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/add_order/widgets/product_images.dart';

class ImagesPart extends GetWidget<AddOrderController> {
  const ImagesPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Order Images'.tr.subtitle(),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            ImagePicker picker = ImagePicker();

            List<XFile> images = await picker.pickMultiImage(
              imageQuality: 60,
            );

            controller.productImages
                .addAll(images.map((e) => File(e.path)).toList());
          },
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              'upload'.iconColored(color: Get.theme.primaryColor, size: 50),
              const SizedBox(height: 5),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Drop your image here, or '.tr,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(
                          color: Colors.black,
                          fontFamily: (Get.locale == const Locale('ar'))
                              ? 'Tajawal'
                              : 'Poppin',
                          height: 1.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'browse'.tr,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(
                          color: Get.theme.primaryColor,
                          fontFamily: (Get.locale == const Locale('ar'))
                              ? 'Tajawal'
                              : 'Poppin',
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              'JPG, PNG (Max 800x400px - 2Mo)'.bodyMedium(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1.5, color: Get.theme.primaryColor),
                      ),
                      child: GlobalButton(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          ImagePicker picker = ImagePicker();

                          XFile? image = await picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 50,
                            preferredCameraDevice: CameraDevice.rear,
                          );

                          controller.productImages.add(File(image!.path));
                        },
                        text: 'Camera'.tr,
                        icon: 'video',
                        textColor: Get.theme.primaryColor,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1.5, color: Get.theme.primaryColor),
                      ),
                      child: GlobalButton(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          ImagePicker picker = ImagePicker();

                          List<XFile> images = await picker.pickMultiImage(
                            imageQuality: 60,
                          );

                          controller.productImages
                              .addAll(images.map((e) => File(e.path)).toList());
                        },
                        text: 'Gallery'.tr,
                        icon: 'upload',
                        textColor: Get.theme.primaryColor,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).decorate(padding: 20, radius: 20),
        ),
        const SizedBox(height: 10),
        const ProductImages(),
        const SizedBox(height: 10),
      ],
    );
  }
}
