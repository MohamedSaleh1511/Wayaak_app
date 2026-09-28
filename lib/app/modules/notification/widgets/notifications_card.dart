import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/notifications_model/notification.dart';

class NotificationsCard extends StatelessWidget {
  final NotificationData notification;
  const NotificationsCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.3),
          child: 'order'.iconColored(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              '${Get.locale == const Locale('ar') ? notification.message!.ar : notification.message!.en}'
                  .bodyMedium(
            weight: FontWeight.w500,
            color: Colors.black,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        if (Get.locale == const Locale('en')) ...{
          'arrow-right'.iconColored(color: Constants.grey),
        } else ...{
          Transform.rotate(
            angle: pi,
            child: 'arrow-right'.iconColored(color: Constants.grey),
          ),
        },
      ],
    ).decorate(padding: 16);
  }
}
