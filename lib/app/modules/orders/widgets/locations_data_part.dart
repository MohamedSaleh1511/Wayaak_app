import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class LocationsDataPart extends StatelessWidget {
  final String sourceLocation;
  final String destinationLocation;
  const LocationsDataPart({
    super.key,
    required this.sourceLocation,
    required this.destinationLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 110,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                'dot'.iconColored(color: Get.theme.primaryColor, size: 20),
                const DottedLine(
                  direction: Axis.vertical,
                  lineLength: 50,
                ),
                'location'.iconColored(color: Constants.grey, size: 20),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '${'From'.tr}:'.caption(color: Constants.grey),
                      sourceLocation.bodyMedium(
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '${'Shipping To'.tr}:'.caption(color: Constants.grey),
                      destinationLocation.bodyMedium(
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
      ).decorate(padding: 18),
    );
  }
}
