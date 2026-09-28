import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/shimmers/order_card_shimmer.dart';
import 'package:wayaak/app/core/widgets/shimmers/shipment_card_shimmer.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak/app/modules/home/widgets/home_appbar.dart';
import 'package:wayaak/app/core/widgets/order_card.dart';
import 'package:wayaak/app/core/widgets/search_card.dart';
import 'package:wayaak/app/modules/home/widgets/shipment_card.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(
        scaffoldKey: controller.scaffoldKey,
        userName: controller.appServices.userName.value,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getBanners();
            controller.getCurrentShipment();
            controller.orderController.getLastOrders();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  SearchCard(
                    text: 'Search on anything'.tr,
                    icon: 'location',
                    onTap: () => Get.toNamed(Routes.search),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.isBannersLoading.value) {
                      return Center(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Constants.grey,
                            ),
                          ),
                        ).shimmer(),
                      );
                    } else {
                      if (controller.bannersList.isEmpty) {
                        return Image.asset(
                          'assets/images/Banner.png',
                          width: Get.width,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return CarouselSlider.builder(
                          itemCount: controller.bannersList.length,
                          itemBuilder: (context, index, realIndex) => ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child:
                                "${Constants.baseUrl}storage/${controller.bannersList[index].image}"
                                    .image(isProfile: false),
                          ),
                          options: CarouselOptions(
                            aspectRatio: 16 / 4,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: false,
                          ),
                        );
                      }
                    }
                  }),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'Last Orders'.tr.subtitle(),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.orders),
                        child: 'View All'
                            .tr
                            .caption(color: Get.theme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (controller.orderController.isLastOrdersLoading.value) ...{
                    Center(
                      child: Column(
                        children: List.generate(
                            3, (index) => const OrderCardShimmer()),
                      ),
                    ),
                  } else ...{
                    if (controller
                        .orderController.lastOrderDatumList.isEmpty) ...{
                      Center(child: 'No data found'.tr.body()),
                    } else ...{
                      ...List.generate(
                        controller.orderController.lastOrderDatumList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: OrderCard(
                              order: controller
                                  .orderController.lastOrderDatumList[index]),
                        ),
                      ),
                    },
                  },
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'Current Shipment'.tr.subtitle(),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.orders, arguments: 4),
                        child: 'View All'
                            .tr
                            .caption(color: Get.theme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.isCurrentShipmentLoading.value) {
                      return const ShipmentCardShimmer();
                    } else {
                      if (controller.currentShipmentData.isEmpty) {
                        return const SizedBox();
                      } else {
                        return ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ShipmentCard(
                            data: controller.currentShipmentData[index],
                          ),
                          itemCount: controller.currentShipmentData.length,
                        );
                      }
                    }
                  }),
                  const SizedBox(height: 130),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
