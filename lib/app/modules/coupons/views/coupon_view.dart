import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/coupons/controllers/coupons_controller.dart';
import 'package:wayaak/app/modules/coupons/widgets/coupon_card.dart';
import 'package:wayaak/app/core/widgets/shimmers/coupon_shimmer.dart';

class CouponsView extends GetView<CouponsController> {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Coupons'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Obx(
            () {
              if (controller.isCouponsLoading.value) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) => const CouponCardShimmer(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: 4,
                );
              } else {
                if (controller.couponsList.isEmpty) {
                  return "No data found".tr.body();
                } else {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) => CouponCard(
                      coupon: controller.couponsList[index],
                      currency: controller.appServices.userCurrencyCode.value,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: controller.couponsList.length,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
