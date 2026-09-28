import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/reviews_model/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: "${Constants.baseUrl}storage/${review.image}".image(),
        ),
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
                        '${review.user}'.subtitle(),
                        RatingBarIndicator(
                          itemCount: 5,
                          rating: double.parse(review.rate!),
                          itemSize: 16,
                          unratedColor: Constants.hintText,
                          itemBuilder: (context, index) => 'star'.iconColored(
                            color: Get.theme.colorScheme.secondary,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  DateFormat("dd/mm/yyyy").format(review.createdAt!).caption(),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: '${review.comment}'.bodyMedium(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
