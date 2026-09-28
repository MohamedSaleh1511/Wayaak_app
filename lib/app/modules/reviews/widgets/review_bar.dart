import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class ReviewBar extends StatelessWidget {
  final int reviewCount;
  final int totalReviews;
  final int filledStars;
  final int outlinedStars;

  const ReviewBar({
    super.key,
    required this.filledStars,
    required this.outlinedStars,
    required this.reviewCount,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          filledStars,
          (index) => 'star'.iconColored(
            color: Get.theme.colorScheme.secondary,
            size: 16,
          ),
        ),
        ...List.generate(
          outlinedStars,
          (index) => 'outline-star'.iconColored(
            color: Constants.grey,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            return Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Constants.softGrey,
              ),
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                height: 8,
                width: c.maxWidth * (reviewCount / totalReviews),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        '$reviewCount'.bodyMedium(color: Colors.black),
      ],
    );
  }
}
