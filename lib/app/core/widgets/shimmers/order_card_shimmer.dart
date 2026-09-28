import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AspectRatio(
        aspectRatio: 16 / 4.8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.3),
              child: 'order'.iconColored(),
            ).shimmer(),
            const SizedBox(width: 10),
            Expanded(
              child: LayoutBuilder(builder: (context, c) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 12,
                      width: c.maxWidth * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Constants.grey,
                      ),
                    ).shimmer(),
                    const SizedBox(height: 5),
                    Container(
                      height: 12,
                      width: c.maxWidth * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Constants.grey,
                      ),
                    ).shimmer(),
                    const SizedBox(height: 5),
                    Container(
                      height: 12,
                      width: c.maxWidth * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Constants.grey,
                      ),
                    ).shimmer(),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Constants.softGrey,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        height: 14,
                        width: c.maxWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Constants.grey,
                        ),
                      ).shimmer(),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(width: 6),
            'arrow-right'.iconColored(color: Constants.grey),
          ],
        ),
      ).decorate(padding: 16),
    );
  }
}
