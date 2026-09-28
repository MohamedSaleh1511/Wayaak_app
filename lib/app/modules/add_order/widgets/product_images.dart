import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';

class ProductImages extends GetWidget<AddOrderController> {
  const ProductImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.productImages.isEmpty) {
        return const SizedBox();
      } else {
        return Column(
          children: List.generate(
            controller.productImages.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Get.generalDialog(
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      Tween<Offset> tween;
                      if (animation.status == AnimationStatus.reverse) {
                        tween =
                            Tween(begin: const Offset(0, 1), end: Offset.zero);
                      } else {
                        tween =
                            Tween(begin: const Offset(0, 1), end: Offset.zero);
                      }

                      return SlideTransition(
                        position: tween.animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.fastEaseInToSlowEaseOut)),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 600),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        InteractiveViewer(
                      child: Image.file(controller.productImages[index]),
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
                        File(controller.productImages[index].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.productImages[index].path
                              .split('/')
                              .last
                              .bodyMedium(color: Colors.black, maxLines: 2),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        ImagePicker picker = ImagePicker();
                        controller.appServices.pickImage(
                          () async {
                            final imageSelected = await picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 50,
                            );
                            if (imageSelected != null) {
                              controller.productImages[index] =
                                  File(imageSelected.path);
                            }
                            Get.back();
                          },
                          () async {
                            final imageSelected = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 50,
                            );
                            if (imageSelected != null) {
                              controller.productImages[index] =
                                  File(imageSelected.path);
                            }
                            Get.back();
                          },
                        );
                      },
                      icon: 'edit2'.iconColored(color: Colors.white),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        controller.productImages.removeAt(index);
                      },
                      icon: 'trash'.iconColored(color: Colors.white),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ).decorate(padding: 8),
            ),
          ),
        );
      }
    });
  }
}
