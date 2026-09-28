import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/order_details_model/driver.dart';

class VehicleDataPart extends StatelessWidget {
  final String vehicleImage;
  final OrderDetailsDriver driver;
  const VehicleDataPart(
      {super.key, required this.vehicleImage, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              '${driver.vehicle!.vehicleMetalPlate}'.subtitle(),
              const SizedBox(height: 3),
              if (driver.vehicle!.type != null)
                '${driver.vehicle!.type!.name}'.bodyMedium(),
              const SizedBox(height: 3),
              InkWell(
                onTap: () {
                  Get.generalDialog(
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      Tween<Offset> tween;
                      if (animation.status == AnimationStatus.reverse) {
                        tween =
                            Tween(begin: const Offset(0, 1), end: Offset.zero);
                      } else {
                        tween =
                            Tween(begin: const Offset(0, 1), end: Offset.zero);
                      }

                      return SlideTransition(
                        position: tween.animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.fastEaseInToSlowEaseOut)),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 600),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        InteractiveViewer(
                      child:
                          '${Constants.baseUrl}storage/${driver.vehicle!.vehiclePhoto}'
                              .image(),
                    ),
                    barrierColor: Colors.black,
                    barrierDismissible: true,
                    barrierLabel: 'image preview',
                  );
                },
                child: 'See vehicle image'.tr.button(
                      decor: TextDecoration.underline,
                    ),
              ),
            ],
          ),
          const SizedBox(width: 25),
          Expanded(
            child: '${Constants.baseUrl}storage/$vehicleImage'.image(
              isProfile: false,
            ),
          ),
        ],
      ).decorate(padding: 18),
    );
  }
}
