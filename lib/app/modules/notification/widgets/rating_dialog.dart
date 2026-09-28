import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';

class RatingDialog extends GetWidget<HomeController> {
  const RatingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            'Rate the driver'.tr.titleSmall(),
            const SizedBox(height: 15),
            Directionality(
              textDirection: TextDirection.ltr,
              child: RatingBar.builder(
                initialRating: 3.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                unratedColor: Colors.grey.shade300,
                itemCount: 5,
                maxRating: 5,
                itemSize: 35.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Get.theme.colorScheme.secondary,
                ),
                onRatingUpdate: (rating) {
                  controller.rate.value = rating;
                },
                updateOnDrag: true,
              ),
            ),
            const SizedBox(height: 15),
            GlobalTextField(
              controller: controller.commentController,
              hintText: 'Enter your comment'.tr,
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            GlobalButton(
              onTap: () {
                controller
                    .addDriverReview(controller.appServices.driverId.value);
              },
              text: "Rate".tr,
              width: Get.width * 0.85,
            ),
          ],
        ),
      ),
    );
  }
}
