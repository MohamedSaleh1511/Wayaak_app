import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';

class ImportancePart extends GetWidget<AddOrderController> {
  const ImportancePart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Importance'.tr.subtitle(),
        const SizedBox(height: 8),
        Obx(
          () {
            return DropdownButtonHideUnderline(
              child: DropdownButton<OrderImportance>(
                icon: 'down-arrow'.iconColored(size: 16),
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 15)
                    .copyWith(end: 25),
                isExpanded: true,
                value: controller.importance.value,
                borderRadius: BorderRadius.circular(15),
                elevation: 2,
                hint: 'Select order importance'.tr.bodyMedium(),
                alignment: Alignment.center,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                items: [
                  DropdownMenuItem(
                    alignment: Alignment.center,
                    value: OrderImportance.regular,
                    child: Row(
                      children: [
                        'importance low'.iconColored(size: 28),
                        const SizedBox(width: 15),
                        'Regular'.tr.bodyMedium(color: Colors.black),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    alignment: Alignment.center,
                    value: OrderImportance.urgent,
                    child: Row(
                      children: [
                        'importance urgent'.iconColored(size: 28),
                        const SizedBox(width: 15),
                        'Urgent'.tr.bodyMedium(color: Colors.black),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  controller.importance.value = value!;
                },
              ).decorate(padding: 2),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
