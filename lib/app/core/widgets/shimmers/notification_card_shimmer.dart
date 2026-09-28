import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class NotificationCardShimmer extends StatelessWidget {
  const NotificationCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.3),
          child: 'order'.iconColored(),
        ).shimmer(),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: c.maxWidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Constants.grey,
                  ),
                ).shimmer(),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: c.maxWidth * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Constants.grey,
                  ),
                ).shimmer(),
              ],
            );
          }),
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
