import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';

class VehicleTypePart extends GetWidget<AddOrderController> {
  const VehicleTypePart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Vehicle Type'.tr.subtitle(),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isVehiclesLoading.value) {
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
            if (controller.vehiclesList.isEmpty) {
              return 'No data found'.tr.body();
            } else {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  icon: 'down-arrow'.iconColored(size: 16),
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 15)
                      .copyWith(end: 25),
                  isExpanded: true,
                  value: controller.vehicleId.value,
                  borderRadius: BorderRadius.circular(15),
                  elevation: 2,
                  hint: 'Select your vehicle type'.tr.bodyMedium(),
                  alignment: Alignment.center,
                  items: List.generate(
                    controller.vehiclesList.length,
                    (index) => DropdownMenuItem(
                      alignment: Alignment.center,
                      value: controller.vehiclesList[index].id!.toString(),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child:
                                '${Constants.baseUrl}storage/${controller.vehiclesList[index].image}'
                                    .image(),
                          ),
                          const SizedBox(width: 15),
                          '${controller.vehiclesList[index].name}'.body(
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    controller.vehicleId.value = value!;
                  },
                ).decorate(padding: 2),
              );
            }
          }
        }),
        const SizedBox(height: 10),
      ],
    );
  }
}
