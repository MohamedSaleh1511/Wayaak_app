import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/add_order/widgets/driver_offer_card.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class OffersView extends GetView<AddOrderController> {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Offers'.tr.titleSmall(color: Colors.black),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.main),
          icon: Transform.flip(
            flipX: Get.locale == const Locale('ar'),
            child: 'Arrow Back'.iconColored(),
          ),
        ),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        "Min. Cost".tr.bodyMedium(),
                        const SizedBox(height: 4),
                        '${double.parse((Get.arguments[0] as String)).toStringAsFixed(2)} ${controller.appServices.userCurrencyCode.value.tr}'
                            .titleSmall(),
                      ],
                    ),
                  ),
                  if ((Get.arguments[2] as String) == '0') ...{
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          "Max. Cost".tr.bodyMedium(),
                          const SizedBox(height: 4),
                          '${double.parse((Get.arguments[1] as String)).toStringAsFixed(2)} ${controller.appServices.userCurrencyCode.value.tr}'
                              .titleSmall(),
                        ],
                      ),
                    ),
                  },
                ],
              ).decorate(padding: 8),
              const SizedBox(height: 15),
              if (controller.socketServices.offersList.isEmpty) ...{
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: "No data found".tr.bodyMedium(),
                )),
              } else ...{
                AnimatedList.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index, animation) => ScaleTransition(
                    scale: animation,
                    child: DriverOfferCard(
                      offer: controller.socketServices.offersList[index],
                    ),
                  ),
                  initialItemCount: controller.socketServices.offersList.length,
                  separatorBuilder: (context, index, animation) =>
                      const SizedBox(height: 10),
                  removedSeparatorBuilder: (context, index, animation) =>
                      const SizedBox(height: 10),
                ),
              },
            ],
          ),
        );
      }),
    );
  }
}
