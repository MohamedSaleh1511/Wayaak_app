import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/routes/app_routes.dart';

import '../controllers/support_controller.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Support'.tr),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            'All Topics'.tr.subtitle(),
            const SizedBox(height: 15),
            UnconstrainedBox(
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => Get.toNamed(Routes.addTicket),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Get.theme.primaryColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      'Music'
                          .iconColored(color: Get.theme.primaryColor, size: 50),
                      const SizedBox(height: 8),
                      'Connect With Support'.tr.bodyMedium(center: true),
                    ],
                  ),
                ).decorate(),
              ),
            ),
            const SizedBox(height: 40),
            'My Tickets'.tr.subtitle(),
            const SizedBox(height: 15),
            ListTile(
              onTap: () {
                controller.getOpenedTickets();
                Get.toNamed(Routes.tickets);
              },
              title: 'Opened Tickets'.tr.body(color: Colors.black),
              trailing: Transform.flip(
                flipX: Get.locale == const Locale('ar'),
                child: 'arrow-right'.iconColored(color: Constants.grey),
              ),
            ),
            const Divider(
              color: Constants.softGrey,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              onTap: () {
                controller.getClosedTickets();
                Get.toNamed(Routes.tickets);
              },
              title: 'Closed Tickets'.tr.body(color: Colors.black),
              trailing: Transform.flip(
                flipX: Get.locale == const Locale('ar'),
                child: 'arrow-right'.iconColored(color: Constants.grey),
              ),
            ),
            const Divider(
              color: Constants.softGrey,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              onTap: () {
                controller.getPendingTickets();
                Get.toNamed(Routes.tickets);
              },
              title: 'Pending Tickets'.tr.body(color: Colors.black),
              trailing: Transform.flip(
                flipX: Get.locale == const Locale('ar'),
                child: 'arrow-right'.iconColored(color: Constants.grey),
              ),
            ),
            const Divider(
              color: Constants.softGrey,
              endIndent: 10,
              indent: 10,
            ),
            const SizedBox(height: 40),
            'Need More Help?'.tr.subtitle(),
            const SizedBox(height: 15),
            ListTile(
              onTap: () {
                controller.getFaq();
                Get.toNamed(Routes.faq);
              },
              title: 'FAQ'.tr.body(color: Colors.black),
              trailing: Transform.flip(
                flipX: Get.locale == const Locale('ar'),
                child: 'arrow-right'.iconColored(color: Constants.grey),
              ),
            ),
            const Divider(
              color: Constants.softGrey,
              endIndent: 10,
              indent: 10,
            ),
          ],
        ),
      ),
    );
  }
}
