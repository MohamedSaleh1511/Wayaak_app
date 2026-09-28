import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';

class PaymentPart extends GetWidget<AddOrderController> {
  const PaymentPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Payment Method'.tr.subtitle(),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isPaymentMethodsLoading.value) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                  ).shimmer(),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsetsDirectional.only(end: 20),
                      height: 12,
                    ).shimmer(),
                  ),
                  const SizedBox(width: 30),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                  ).shimmer(),
                ],
              ),
            ).decorate(padding: 10);
          } else {
            if (controller.paymentMethodsList.isEmpty) {
              return 'No data found'.tr.body();
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    (controller.paymentMethodsList
                                    .where((p0) =>
                                        p0.id.toString() ==
                                        controller
                                            .appServices.paymentMethod.value)
                                    .first
                                    .id ==
                                1
                            ? 'cash'
                            : controller.paymentMethodsList
                                        .where((p0) =>
                                            p0.id.toString() ==
                                            controller.appServices.paymentMethod
                                                .value)
                                        .first
                                        .id ==
                                    2
                                ? 'credit-card'
                                : 'walletpayment')
                        .iconColored(size: 35),
                    const SizedBox(width: 15),
                    Expanded(
                      child:
                          '${controller.paymentMethodsList.where((p0) => p0.id.toString() == controller.appServices.paymentMethod.value).first.name}'
                              .body(
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Get.bottomSheet(
                          BottomSheet(
                            backgroundColor: Colors.transparent,
                            onClosing: () {
                              FocusScope.of(context).unfocus();
                            },
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  'Select Payment Method'.tr.subtitle(),
                                  const SizedBox(height: 20),
                                  Obx(() {
                                    if (controller
                                        .isPaymentMethodsLoading.value) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      if (controller
                                          .paymentMethodsList.isEmpty) {
                                        return 'No data found'.tr.body();
                                      } else {
                                        return Column(
                                          children: List.generate(
                                            controller
                                                .paymentMethodsList.length,
                                            (index) => RadioListTile<int>(
                                              value: controller
                                                  .paymentMethodsList[index]
                                                  .id!,
                                              groupValue: controller
                                                      .appServices
                                                      .paymentMethod
                                                      .value
                                                      .isEmpty
                                                  ? 0
                                                  : int.parse(controller
                                                      .appServices
                                                      .paymentMethod
                                                      .value),
                                              title:
                                                  '${controller.paymentMethodsList[index].name}'
                                                      .body(),
                                              secondary: (controller
                                                              .paymentMethodsList[
                                                                  index]
                                                              .id ==
                                                          1
                                                      ? 'cash'
                                                      : controller
                                                                  .paymentMethodsList[
                                                                      index]
                                                                  .id ==
                                                              2
                                                          ? 'credit-card'
                                                          : 'walletpayment')
                                                  .iconColored(size: 35),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .trailing,
                                              onChanged: (value) {
                                                controller
                                                    .appServices
                                                    .paymentMethod
                                                    .value = value.toString();
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }),
                                  const Spacer(),
                                  GlobalButton(
                                    onTap: () {
                                      Get.back();
                                    },
                                    text: 'Save'.tr,
                                    width: double.infinity,
                                  ),
                                ],
                              ).decorate(width: Get.width * 0.92, padding: 20),
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      icon: 'edit'.iconColored(),
                    ),
                  ],
                ),
              ).decorate(padding: 10);
            }
          }
        }),
        const SizedBox(height: 15),
      ],
    );
  }
}
