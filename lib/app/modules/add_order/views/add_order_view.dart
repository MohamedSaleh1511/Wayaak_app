import 'dart:developer';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/add_order/widgets/add_order_parts/coupons_part.dart';
import 'package:wayaak/app/modules/add_order/widgets/add_order_parts/delivery_addresses_part.dart';
import 'package:wayaak/app/modules/add_order/widgets/add_order_parts/payment_part.dart';
import 'package:wayaak/app/modules/add_order/widgets/add_order_parts/title_desc_part.dart';

class AddOrderView extends GetView<AddOrderController> {
  const AddOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Order Anything".tr.titleSmall(color: Colors.black),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Transform.flip(
            flipX: Get.locale == const Locale('ar'),
            child: 'Arrow Back'.iconColored(),
          ),
        ),
        actions: [
          CountryFlag.fromCountryCode(
            controller.appServices.userCountryCode.value,
            width: 30,
            height: 30,
            shape: const Circle(),
          ),
          const SizedBox(width: 10),
        ],
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleDescPart(),
              const DeliveryAddressesPart(),
              // const ImportancePart(),
              // const VehicleTypePart(),
              const PaymentPart(),
              const CouponsPart(),
              GlobalButton(
                onTap: () async {
                  log("isValid ${controller.addOrderFormKey.currentState!.validate()}");
                  if (controller.addOrderFormKey.currentState!.validate()) {
                    controller.addOrderFormKey.currentState!.save();
                    if (controller.currentLocation.value.title == null ||
                        controller.destinationLocation.value.title == null) {
                      Ui.errorGetBar(
                          message:
                              "You have to enter the source location and destination location"
                                  .tr);
                    } else {
                      if (controller.currentLocation.value ==
                          controller.destinationLocation.value) {
                        Ui.errorGetBar(
                            message:
                                "Please select two different locations".tr);
                      } else {
                        if (controller.productImages.isNotEmpty) {
                          controller.getMinMaxDeliveryCost().then((e) {
                            if (e) {
                              Get.generalDialog(
                                transitionBuilder: (context, animation,
                                        secondaryAnimation, child) =>
                                    child.dialogTransition(animation),
                                transitionDuration:
                                    const Duration(milliseconds: 800),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        UnconstrainedBox(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/onboarding2.png',
                                        width: Get.width * 0.5,
                                      ),
                                      const SizedBox(height: 15),
                                      'Delivery Price'.tr.subtitle(),
                                      const SizedBox(height: 5),
                                      '${controller.deliveryCostModel.value.message}'
                                          .bodyMedium(center: true),
                                      const SizedBox(height: 15),
                                      GlobalButton(
                                        onTap: () async {
                                          Get.back();
                                          controller.addOrder();
                                        },
                                        text: 'Continue'.tr,
                                        width: double.infinity,
                                      ),
                                      const SizedBox(height: 5),
                                      GlobalButton(
                                        onTap: () {
                                          Get.back();
                                        },
                                        text: 'Cancel'.tr,
                                        width: double.infinity,
                                        color: Constants.grey.withOpacity(0.15),
                                        textColor: Constants.accent,
                                      ),
                                    ],
                                  ).decorate(
                                      padding: 15, width: Get.width * 0.9),
                                ),
                              );
                            }
                          });
                        } else {
                          Ui.errorGetBar(
                              message: 'Please add order images (min: 1)'.tr);
                        }
                      }
                    }
                  }
                },
                text: 'Send Request'.tr,
                width: Get.width,
                height: 58,
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
