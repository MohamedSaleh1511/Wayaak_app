import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class LocationCardShimmer extends StatelessWidget {
  const LocationCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ).shimmer(),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15,
                width: Get.width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ).shimmer(),
              const SizedBox(height: 8),
              Container(
                height: 13,
                width: Get.width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ).shimmer(),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 35,
          width: 35,
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ).shimmer(),
        const SizedBox(width: 4),
        Container(
          height: 35,
          width: 35,
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ).shimmer(),
      ],
    ).decorate(padding: 12);
  }
}
