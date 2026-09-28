import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/offers_model.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';

class DriverOfferCard extends GetWidget<AddOrderController> {
  final Offers offer;
  const DriverOfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: "${Constants.baseUrl}storage/${offer.driverAvatar}".image(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '${offer.driverName}'.subtitle(),
                      const SizedBox(height: 3),
                      RatingBarIndicator(
                        itemCount: 5,
                        unratedColor: Colors.grey.shade400,
                        rating: double.parse(offer.rate ?? "0"),
                        itemSize: 18,
                        itemBuilder: (context, index) => 'star'.iconColored(
                          size: 18,
                          color: Get.theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      '${offer.price} ${controller.appServices.userCurrencyCode.value.tr}'
                          .bodyMedium(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: GlobalButton(
                      onTap: () {
                        controller.declineRequest(offer.id!);
                      },
                      text: 'Decline'.tr,
                      icon: 'Close',
                      color: Get.theme.colorScheme.error,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GlobalButton(
                      onTap: () {
                        controller.acceptRequest(offer.id!, offer.price!);
                        controller.socketServices.driverRealTimeLoc.value =
                            LatLng(
                          double.parse(offer.latitude!),
                          double.parse(offer.longitude!),
                        );
                        controller.socketServices.unsubscribeChannel(
                            'private-order-offers.${controller.appServices.orderNum}');
                      },
                      text: 'Accept'.tr,
                      icon: 'check',
                      color: Constants.green,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).decorate(padding: 15);
  }
}
