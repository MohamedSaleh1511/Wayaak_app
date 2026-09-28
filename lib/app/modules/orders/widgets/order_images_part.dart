import 'package:flutter/material.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/order_details_model/product_image.dart';

class OrderImagesPart extends StatelessWidget {
  final List<ProductImage> images;
  const OrderImagesPart({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: AspectRatio(
        aspectRatio: 16 / 8,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: "${Constants.baseUrl}storage/${images[index].image}"
                .image(isProfile: false),
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemCount: images.length,
        ),
      ).decorate(),
    );
  }
}
