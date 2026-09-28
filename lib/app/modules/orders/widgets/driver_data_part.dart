import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/order_details_model/driver.dart';
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class DriverDataPart extends GetView<OrdersController> {
  final OrderDetailsDriver driver;
  const DriverDataPart({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 33,
            backgroundColor: Get.theme.colorScheme.secondary,
            child: ClipOval(
              child: SizedBox(
                width: 60,
                height: 60,
                child: '${Constants.baseUrl}storage/${driver.driverPhoto!}'
                    .image(isTap: false),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '${driver.name}'.subtitle(),
              const SizedBox(height: 3),
              if (double.parse(driver.rate!) > 3.0)
                'Top ranked driver'.bodyMedium(),
              const SizedBox(height: 3),
              RatingBarIndicator(
                itemCount: 5,
                rating: double.parse(driver.rate!),
                itemSize: 16,
                itemBuilder: (context, index) => 'star'.iconColored(
                  color: Get.theme.colorScheme.secondary,
                  size: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton.filled(
            onPressed: () {
              launch(Uri(scheme: 'tel', path: driver.phone));
            },
            icon: 'phone'.iconColored(color: Colors.white),
          ),
          const SizedBox(width: 3),
          IconButton.filled(
            onPressed: () {
              controller.getChatMessages(driver.id!).then((val) {
                controller.socketServices.chatChannelName.value =
                    "private-chat.${controller.chatId.value}";
                controller.socketServices.checkBroadcastAuth(
                    "private-chat.${controller.chatId.value}");
              });

              Get.toNamed(Routes.chatMessages, arguments: [
                driver.driverPhoto!,
                driver.name!,
                driver.id!,
                controller.chatId.value,
              ]);
            },
            icon: 'message-text'.iconColored(color: Colors.white),
          ),
        ],
      ).decorate(padding: 12),
    );
  }
}
