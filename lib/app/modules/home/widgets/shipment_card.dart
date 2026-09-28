import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/order_details_model/data.dart';

class ShipmentCard extends StatelessWidget {
  final OrderDetailsDataa data;
  const ShipmentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: 'order'.iconColored(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '${data.driver!.name}'.subtitle(),
                    '${'Order Number'.tr}: ${data.orderNum}'.bodyMedium(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Column(
                    children: [
                      'dot'
                          .iconColored(color: Get.theme.primaryColor, size: 20),
                      const Expanded(
                        child: DottedLine(
                          direction: Axis.vertical,
                        ),
                      ),
                      'dot'.iconColored(color: Constants.grey, size: 20),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            'From:'.tr.caption(color: Constants.grey),
                            '${data.currentLocation!.title}'.bodyMedium(
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            'Shipping to:'.tr.caption(color: Constants.grey),
                            '${data.destinationLocation!.title}'.bodyMedium(
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 15),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Status:'.tr,
                    style: Get.textTheme.bodyLarge!.merge(
                      TextStyle(
                        color: Colors.black,
                        fontFamily: (Get.locale == const Locale('ar'))
                            ? 'Tajawal'
                            : 'Poppin',
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: data.orderStatus!.name.tr,
                    style: Get.textTheme.bodyMedium!.merge(
                      TextStyle(
                        color: Constants.textColor,
                        fontFamily: (Get.locale == const Locale('ar'))
                            ? 'Tajawal'
                            : 'Poppin',
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).decorate(color: Constants.softGrey, padding: 15, shadow: false);
  }
}
