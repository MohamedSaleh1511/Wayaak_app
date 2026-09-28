import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/order_card.dart';
import 'package:wayaak/app/core/widgets/shimmers/order_card_shimmer.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Your Orders'.tr.title(color: Colors.black),
        centerTitle: false,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: DefaultTabController(
        length: 6,
        initialIndex: Get.arguments.runtimeType == int ? Get.arguments : 0,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar.medium(
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              collapsedHeight: kToolbarHeight + 5,
              expandedHeight: kToolbarHeight + 5,
              toolbarHeight: kToolbarHeight + 5,
              automaticallyImplyLeading: false,
              forceElevated: false,
              bottom: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0.2,
                tabAlignment: TabAlignment.start,
                unselectedLabelColor: Constants.grey,
                labelColor: context.theme.primaryColor,
                indicatorColor: context.theme.colorScheme.secondary,
                labelStyle: Get.textTheme.bodyMedium!.merge(
                  TextStyle(
                    color: Get.theme.primaryColor,
                    fontFamily: (Get.locale == const Locale('en'))
                        ? 'Poppin'
                        : 'Almarai',
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                unselectedLabelStyle: Get.textTheme.bodyMedium!.merge(
                  TextStyle(
                    color: Constants.grey,
                    fontFamily: (Get.locale == const Locale('ar'))
                        ? 'Almarai'
                        : 'Poppin',
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tabs: [
                  Tab(text: 'All'.tr),
                  Tab(text: 'pending'.tr),
                  Tab(text: 'waitingforDriver'.tr),
                  Tab(text: 'driverAccepted'.tr),
                  Tab(text: 'delivered'.tr),
                  Tab(text: 'cancelled'.tr),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: List.generate(
              6,
              (index) => Obx(() {
                if (controller.isOrdersLoading.value) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 15)
                        .copyWith(bottom: kBottomNavigationBarHeight + 30),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) => const OrderCardShimmer(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: 8,
                  );
                } else {
                  if (controller.orderDatumList.isEmpty) {
                    return Center(child: 'No data found'.tr.body());
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await controller.getOrders();
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 15)
                            .copyWith(bottom: kBottomNavigationBarHeight + 30),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, i) => (index == 0)
                            ? OrderCard(order: controller.orderDatumList[i])
                            : OrderCard(
                                order: controller.orderDatumList
                                    .where((v) =>
                                        v.orderStatus ==
                                        controller.orderStatuses[index])
                                    .toList()[i]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: index == 0
                            ? controller.orderDatumList.length
                            : controller.orderDatumList
                                .where((v) =>
                                    v.orderStatus ==
                                    controller.orderStatuses[index])
                                .toList()
                                .length,
                      ),
                    );
                  }
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
