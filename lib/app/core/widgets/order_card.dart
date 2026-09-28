import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/orders_model/datum.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class OrderCard extends GetWidget<HomeController> {
  final OrderDatum order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        controller.orderController.orderDetails(order.orderNum!);
        if (order.orderStatus == OrderStatus.driverAccepted) {
          controller.socketServices.checkBroadcastAuth(
              "private-user-location.${controller.appServices.userId.value}");

          controller.socketServices.driverRealTimeLoc.value = LatLng(
            double.parse(order.driver!.latitude!),
            double.parse(order.driver!.longitude!),
          );

          controller.socketServices.driverLoc.value = LatLng(
            double.parse(order.driver!.latitude!),
            double.parse(order.driver!.longitude!),
          );

          Get.toNamed(Routes.orderDetails, arguments: 'track');
        } else {
          Get.toNamed(Routes.orderDetails, arguments: '');
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.3),
            child: 'order'.iconColored(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '${"Order Number".tr}: ${order.orderNum}'.titleSmall(),
                '${order.description}'.bodyMedium(maxLines: 1),
                const SizedBox(height: 5),
                order.orderStatus!.getStatus(),
              ],
            ),
          ),
          const SizedBox(width: 6),
          if (Get.locale == const Locale('en'))
            'arrow-right'.iconColored(color: Constants.grey)
          else
            Transform.rotate(
              angle: pi,
              child: 'arrow-right'.iconColored(color: Constants.grey),
            ),
        ],
      ).decorate(padding: 16),
    );
  }
}
