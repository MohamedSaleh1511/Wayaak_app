import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/core/widgets/shimmers/all_reviews_card_shimmer.dart';
import 'package:wayaak/app/core/widgets/shimmers/review_card_shimmer.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/reviews/widgets/all_reviews_card.dart';
import 'package:wayaak/app/modules/reviews/widgets/review_card.dart';
import '../controllers/reviews_controller.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Reviews'.tr),
      body: Obx(
        () {
          if (controller.isReviewsLoading.value) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Column(
                  children: [
                    const AllReviewsCardShimmer(),
                    const SizedBox(height: 15),
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      itemBuilder: (context, index) =>
                          const ReviewCardShimmer(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (controller.reviewsModel.value.data == null) {
              return Center(child: "No data found".tr.bodyMedium());
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Column(
                    children: [
                      AllReviewsCard(
                        totalReviews: double.parse(
                            controller.reviewsModel.value.data!.myTotalStars!),
                        reviewsCount:
                            controller.reviewsModel.value.data!.reviews!.length,
                        rate1Count:
                            controller.reviewsModel.value.data!.usersGive1Star!,
                        rate2Count: controller
                            .reviewsModel.value.data!.usersGive2Stars!,
                        rate3Count: controller
                            .reviewsModel.value.data!.usersGive3Stars!,
                        rate4Count: controller
                            .reviewsModel.value.data!.usersGive4Stars!,
                        rate5Count: controller
                            .reviewsModel.value.data!.usersGive5Stars!,
                      ),
                      const SizedBox(height: 15),
                      ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount:
                            controller.reviewsModel.value.data!.reviews!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        itemBuilder: (context, index) => ReviewCard(
                          review: controller
                              .reviewsModel.value.data!.reviews![index],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
