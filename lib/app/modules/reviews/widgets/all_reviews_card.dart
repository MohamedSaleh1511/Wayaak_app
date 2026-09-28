import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/reviews/widgets/review_bar.dart';

class AllReviewsCard extends StatelessWidget {
  final double totalReviews;
  final int reviewsCount;
  final int rate1Count;
  final int rate2Count;
  final int rate3Count;
  final int rate4Count;
  final int rate5Count;
  const AllReviewsCard({
    super.key,
    required this.totalReviews,
    required this.reviewsCount,
    required this.rate1Count,
    required this.rate2Count,
    required this.rate3Count,
    required this.rate4Count,
    required this.rate5Count,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$totalReviews',
                      style: Get.textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppin',
                      ),
                    ),
                    TextSpan(
                      text: '/5',
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                        fontFamily: 'Poppin',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              '$reviewsCount ${'Reviews'.tr}'
                  .body(color: Colors.black, center: true),
            ],
          ),
          VerticalDivider(
            width: 30,
            color: Constants.grey.withOpacity(0.3),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ReviewBar(
                  reviewCount: rate1Count,
                  filledStars: 5,
                  outlinedStars: 0,
                  totalReviews: reviewsCount,
                ),
                ReviewBar(
                  reviewCount: rate2Count,
                  filledStars: 4,
                  outlinedStars: 1,
                  totalReviews: reviewsCount,
                ),
                ReviewBar(
                  reviewCount: rate3Count,
                  filledStars: 3,
                  outlinedStars: 2,
                  totalReviews: reviewsCount,
                ),
                ReviewBar(
                  reviewCount: rate4Count,
                  filledStars: 2,
                  outlinedStars: 3,
                  totalReviews: reviewsCount,
                ),
                ReviewBar(
                  reviewCount: rate5Count,
                  filledStars: 1,
                  outlinedStars: 4,
                  totalReviews: reviewsCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
