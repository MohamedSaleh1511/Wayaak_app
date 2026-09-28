import 'package:flutter/material.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class ChatCardShimmer extends StatelessWidget {
  const ChatCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 3.3,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Constants.grey,
          ).shimmer(),
          const SizedBox(width: 10),
          Expanded(
            child: LayoutBuilder(builder: (context, c) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 15,
                    width: c.maxWidth * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants.grey,
                    ),
                  ).shimmer(),
                  const SizedBox(height: 5),
                  Container(
                    height: 10,
                    width: c.maxWidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants.grey,
                    ),
                  ).shimmer(),
                ],
              );
            }),
          ),
          const SizedBox(width: 10),
          "00:00".caption().shimmer(),
        ],
      ),
    ).decorate(padding: 15);
  }
}
