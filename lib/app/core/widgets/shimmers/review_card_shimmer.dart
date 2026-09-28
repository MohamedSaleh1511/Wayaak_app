import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class ReviewCardShimmer extends StatelessWidget {
  const ReviewCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ).shimmer(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 13,
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ).shimmer(),
                        RatingBarIndicator(
                          itemCount: 5,
                          rating: 5.0,
                          itemSize: 16,
                          unratedColor: Constants.hintText,
                          itemBuilder: (context, index) => 'star'.iconColored(
                            color: Get.theme.colorScheme.secondary,
                            size: 16,
                          ),
                        ).shimmer(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 12,
                    width: Get.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ).shimmer(),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: Container(
                  height: 12,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ).shimmer(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
