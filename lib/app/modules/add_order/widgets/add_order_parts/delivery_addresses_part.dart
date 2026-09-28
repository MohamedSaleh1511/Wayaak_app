import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/add_order/widgets/order_location_map_picker.dart';

class DeliveryAddressesPart extends GetWidget<AddOrderController> {
  const DeliveryAddressesPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Delivery Addresses'.tr.subtitle(),
          const SizedBox(height: 5),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              FocusScope.of(context).unfocus();
              Get.to(() => const OrderLocationMapPicker(locationType: 0));
            },
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.primaryColor,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: 'flag'
                      .iconColored(color: Get.theme.primaryColor, size: 25),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '${'From'.tr}:'.caption(),
                      (controller.currentLocation.value.title == null
                              ? 'Select Ordering Location'.tr
                              : controller.currentLocation.value.title!)
                          .bodyMedium(color: Colors.black),
                    ],
                  ),
                ),
                'location'.iconColored(color: Colors.black),
              ],
            ).decorate(padding: 15),
          ),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              FocusScope.of(context).unfocus();
              Get.to(() => const OrderLocationMapPicker(locationType: 1));
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.primaryColor,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: 'box'
                      .iconColored(color: Get.theme.primaryColor, size: 15),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '${'Shipping To'.tr}:'.caption(),
                      (controller.destinationLocation.value.title == null
                              ? 'Select Receiving Location'.tr
                              : controller.destinationLocation.value.title!)
                          .bodyMedium(color: Colors.black),
                    ],
                  ),
                ),
                'location'.iconColored(color: Colors.black),
              ],
            ).decorate(padding: 15),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }
}
