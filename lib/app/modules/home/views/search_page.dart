import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/core/widgets/order_card.dart';
import 'package:wayaak/app/core/widgets/shimmers/order_card_shimmer.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';

class SearchPage extends GetView<HomeController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Search'.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Hero(
              tag: 'search card',
              child: Material(
                child: Container(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  decoration: BoxDecoration(
                    color: Constants.softGrey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GlobalTextField(
                    controller: controller.searchTextController,
                    hintText: "Search in your orders".tr,
                    prefixIcon: 'search',
                    noBorder: true,
                    contentPadding: 16,
                    suffixText: "Search".tr,
                    suffixColor: Get.theme.primaryColor,
                    onSuffixTap: () {
                      if (controller.searchTextController.text
                          .trim()
                          .isNotEmpty) {
                        controller.searchOrders();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Obx(
              () {
                if (controller.isSearchOrdersLoading.value) {
                  return Center(
                    child: Column(
                      children:
                          List.generate(6, (index) => const OrderCardShimmer()),
                    ),
                  );
                } else {
                  if (controller.searchOrderData.isEmpty) {
                    return const Center(child: SizedBox());
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          OrderCard(order: controller.searchOrderData[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                      itemCount: controller.searchOrderData.length,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
