import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/shimmers/notification_card_shimmer.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/notification/widgets/notifications_card.dart';
import 'package:wayaak/app/routes/app_routes.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Notifications'.tr.titleSmall(color: Colors.black),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Transform.flip(
            flipX: Get.locale == const Locale('ar'),
            child: 'Arrow Back'.iconColored(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.clearNotifications(),
            child: "Clear All".tr.caption(
                  color: Constants.accent,
                  weight: FontWeight.bold,
                ),
          ),
        ],
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: Obx(() {
        if (controller.isNotificationsLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => const NotificationCardShimmer(),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: 5,
          );
        } else {
          if (controller.notificationsList.isEmpty) {
            return Center(child: 'No data found'.tr.body());
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                controller.getNotifications();
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    controller.appServices.notificationId.value =
                        controller.notificationsList[index].id!;
                    switch (controller.notificationsList[index].type) {
                      case 'new-order':
                        controller.markAsRead(
                            controller.notificationsList[index].id!);
                        if (controller.notificationsList[index].orderNum !=
                            null) {
                          controller.ordersController.orderDetails(
                              controller.notificationsList[index].orderNum!);
                          Get.toNamed(Routes.orderDetails);
                        }
                        break;
                      case 'admin-reply-ticket':
                        controller.markAsRead(
                            controller.notificationsList[index].id!);
                        if (controller.notificationsList[index].ticketNum !=
                            null) {
                          controller.supportController.ticketReplies.value = [];
                          controller.supportController.getTicketReplies(
                              controller.notificationsList[index].ticketNum!);
                          Get.toNamed(Routes.ticketChat,
                              arguments: controller
                                  .notificationsList[index].ticketNum!);
                        }
                        break;
                      case 'chat':
                        controller.markAsRead(
                            controller.notificationsList[index].id!);
                        // Close any open dialogs before navigating back
                        if (Get.isDialogOpen ?? false) {
                          Get.back();
                        }
                        Get.back();
                        controller.homeController.pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeInOut,
                        );
                        controller.homeController.currentIndex.value = 2;
                        break;
                      case 'order-delivered':
                        controller.appServices.orderId.value = controller
                            .notificationsList[index].orderId!
                            .toString();
                        controller.homeController.orderStatus(
                          orderNum: int.parse(
                              controller.notificationsList[index].orderNum ??
                                  '0'),
                          driverId:
                              controller.notificationsList[index].driverId!,
                          payment:
                              controller.notificationsList[index].payment ?? '',
                          randomNumber:
                              controller.notificationsList[index].randomNumber,
                          messageAr:
                              controller.notificationsList[index].message!.ar ??
                                  '',
                          messageEn:
                              controller.notificationsList[index].message!.en ??
                                  '',
                          totalPrice:
                              controller.notificationsList[index].totalPrice ??
                                  '',
                          readAt: controller.notificationsList[index].readAt,
                          paymentUrl:
                              controller.notificationsList[index].paymentUrl,
                        );
                        break;
                      case 'wallet-charged':
                        // Close any open dialogs before navigating back
                        if (Get.isDialogOpen ?? false) {
                          Get.back();
                        }
                        Get.back();
                        controller.homeController.pageController.animateToPage(
                          3,
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeInOut,
                        );
                        controller.homeController.currentIndex.value = 3;
                        break;
                      default:
                    }
                  },
                  child: NotificationsCard(
                      notification: controller.notificationsList[index]),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: controller.notificationsList.length,
              ),
            );
          }
        }
      }),
    );
  }
}
