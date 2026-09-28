import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/custom_delegate.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import '../controllers/profits_controller.dart';

class ProfitsView extends GetView<ProfitsController> {
  const ProfitsView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: 'Profits'.tr.title(color: Colors.black),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              if (Get.isSnackbarOpen) {
                Get.closeCurrentSnackbar();
              }
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
              Get.back();
            },
            icon: 'Arrow Back'.iconColored(),
          ),
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          actions: [
            GlobalButton(
              onTap: () {},
              text: 'Add'.tr,
              icon: 'Plus',
            ),
            const SizedBox(width: 3),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    'Amount Balance'
                        .tr
                        .title(color: Colors.black, weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    '0.0 ${controller.appServices.userCurrencyCode.value.tr}'
                        .title(),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: MyDelegate(
                TabBar(
                  dividerColor: Colors.transparent,
                  physics: const BouncingScrollPhysics(),
                  labelColor: Get.theme.primaryColor,
                  unselectedLabelColor: Constants.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    border: BorderDirectional(
                      bottom:
                          BorderSide(color: Get.theme.primaryColor, width: 1),
                    ),
                  ),
                  indicatorWeight: 0.0,
                  padding: const EdgeInsets.all(4),
                  labelStyle: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(text: 'Done'.tr),
                    Tab(text: 'In Progress'.tr),
                  ],
                ),
              ),
              pinned: true,
              floating: true,
            ),
          ],
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/profit.png'),
                    const SizedBox(height: 8),
                    'You Did Not Take Any Order'.bodyMedium(),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/profit.png'),
                    const SizedBox(height: 8),
                    'You Did Not Take Any Order'.bodyMedium(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
