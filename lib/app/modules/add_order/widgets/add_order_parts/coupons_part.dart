import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/coupons_model/coupon.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/coupons/widgets/coupon_card.dart';
import 'package:wayaak/app/core/widgets/shimmers/coupon_shimmer.dart';

class CouponsPart extends GetWidget<AddOrderController> {
  const CouponsPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'Coupon'.tr.subtitle(),
                GlobalButton(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    controller.couponsController.getCoupons();
                    Get.bottomSheet(
                      BottomSheet(
                        backgroundColor: Colors.transparent,
                        onClosing: () {},
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              'Select Coupon'.tr.subtitle(),
                              const SizedBox(height: 20),
                              Expanded(
                                child: Obx(
                                  () {
                                    if (controller.couponsController
                                        .isCouponsLoading.value) {
                                      return ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: 3,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 6),
                                        itemBuilder: (context, index) =>
                                            const CouponCardShimmer(),
                                      );
                                    } else {
                                      if (controller.couponsController
                                          .couponsList.isEmpty) {
                                        return 'No data found'.tr.body();
                                      } else {
                                        List<Coupon> coupons = controller
                                            .couponsController.couponsList
                                            .where((e) => e.expiredAt!
                                                .isAfter(DateTime.now()))
                                            .toList();
                                        return ListView.separated(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: coupons.length,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            onTap: () {
                                              controller.coupon.value =
                                                  coupons[index];
                                              Get.back();
                                            },
                                            child: CouponCard(
                                              coupon: coupons[index],
                                              currency: controller.appServices
                                                  .userCurrencyCode.value,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ).decorate(width: Get.width * 0.92, padding: 20),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                    );
                  },
                  icon: 'Plus',
                  text: 'Add Coupon'.tr,
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (controller.coupon.value.code == null)
              'You Don’t Have Any Coupon Yet'.tr.bodyMedium().decorate(
                    padding: 15,
                    width: double.infinity,
                  )
            else
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CouponCard(
                    coupon: controller.coupon.value,
                    currency: controller.appServices.userCurrencyCode.value,
                  ),
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: IconButton(
                      onPressed: () {
                        controller.coupon.value = Coupon();
                      },
                      iconSize: 30,
                      icon:
                          const Icon(Icons.cancel_outlined, color: Colors.red),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }
}
