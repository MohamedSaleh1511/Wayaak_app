import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/order_details_model/data.dart';
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';
import 'package:wayaak/app/modules/orders/widgets/driver_data_part.dart';
import 'package:wayaak/app/modules/orders/widgets/locations_data_part.dart';
import 'package:wayaak/app/modules/orders/widgets/order_data_part.dart';
import 'package:wayaak/app/modules/orders/widgets/order_details_map.dart';
import 'package:wayaak/app/modules/orders/widgets/order_images_part.dart';
import 'package:wayaak/app/modules/orders/widgets/tracking_map_part.dart';
import 'package:wayaak/app/modules/orders/widgets/vehicle_data.dart';

class OrderDetailsView extends GetView<OrdersController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments == 'track') {
      Get.log("There is a Tracking");
    } else {
      Get.log("No Tracking");
    }
    return Scaffold(
      appBar: AppBar(
        title: 'Order Details'.tr.titleSmall(color: Colors.black),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            if (Get.isSnackbarOpen) {
              Get.closeCurrentSnackbar();
            }
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
            Get.back();
          },
          icon: Transform.flip(
            flipX: Get.locale == const Locale('ar'),
            child: 'Arrow Back'.iconColored(),
          ),
        ),
        actions: [
          Obx(() {
            if (controller.isOrderDetailsLoading.value) {
              return const SizedBox();
            } else {
              if (controller.orderDetailsData.value.data!.orderStatus ==
                      OrderStatus.waitingforDriver ||
                  controller.orderDetailsData.value.data!.orderStatus ==
                      OrderStatus.pending) {
                return TextButton(
                  onPressed: () async {
                    OrderDetailsDataa data =
                        controller.orderDetailsData.value.data!;
                    controller.currentLat.value =
                        double.parse(data.currentLocation!.latitude!);
                    controller.currentLong.value =
                        double.parse(data.currentLocation!.longitude!);
                    controller.destLat.value =
                        double.parse(data.destinationLocation!.latitude!);
                    controller.destLong.value =
                        double.parse(data.destinationLocation!.longitude!);
                    controller.appServices.orderNum.value =
                        data.orderNum!.toString();
                    controller.socketServices.checkBroadcastAuth(
                        "private-order-offers.${data.orderNum!}");

                    controller.getDeliveryCost(
                      orderNum: data.orderNum!,
                      importance: data.urgent == 'No' ? 0 : 1,
                      // countryId: data.country == 'Egypt' ? 1 : 3,
                      vehicleId: data.vehicleCategory!.id!,
                    );
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: "Show Offers".tr.caption(
                        color: Constants.accent,
                        weight: FontWeight.bold,
                      ),
                );
              } else {
                return const SizedBox();
              }
            }
          }),
        ],
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: Obx(() {
        if (controller.isOrderDetailsLoading.value) {
          return Center(
            child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
          );
        } else {
          OrderDetailsDataa data = controller.orderDetailsData.value.data!;
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: 9 / 16,
                child: (Get.arguments == 'track' &&
                        data.orderStatus == OrderStatus.driverAccepted)
                    ? LiveTrackingMap(
                        sourceLocation: LatLng(
                          double.parse(data.currentLocation!.latitude ?? '0.0'),
                          double.parse(
                              data.currentLocation!.longitude ?? '0.0'),
                        ),
                        destinationLocation: LatLng(
                          double.parse(
                              data.destinationLocation!.latitude ?? '0.0'),
                          double.parse(
                              data.destinationLocation!.longitude ?? '0.0'),
                        ),
                      )
                    : OrderDetailsMap(
                        sourceLocation: LatLng(
                          double.parse(data.currentLocation!.latitude ?? '0.0'),
                          double.parse(
                              data.currentLocation!.longitude ?? '0.0'),
                        ),
                        destinationLocation: LatLng(
                          double.parse(
                              data.destinationLocation!.latitude ?? '0.0'),
                          double.parse(
                              data.destinationLocation!.longitude ?? '0.0'),
                        ),
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: DraggableScrollableSheet(
                  minChildSize: 0.1,
                  maxChildSize: 1.0,
                  initialChildSize: 0.1,
                  snap: true,
                  snapAnimationDuration: const Duration(milliseconds: 300),
                  builder: (context, scrollController) => Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 6,
                            width: 45,
                            margin: const EdgeInsets.symmetric(vertical: 10)
                                .copyWith(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          "Drag to see order details".tr.body().shimmer(
                                baseColor: Colors.black87,
                                highlightColor: Colors.grey.shade300,
                                duration: 2000,
                              ),
                          if (data.driver != null) ...{
                            VehicleDataPart(
                              vehicleImage: data.vehicleCategory!.image!,
                              driver: data.driver!,
                            ),
                            const SizedBox(height: 12),
                            DriverDataPart(driver: data.driver!),
                            const SizedBox(height: 12.01),
                          },
                          LocationsDataPart(
                            sourceLocation: data.currentLocation!.title ?? "",
                            destinationLocation:
                                data.destinationLocation!.title ?? "",
                          ),
                          const SizedBox(height: 12),
                          OrderDataPart(
                            orderNum: data.orderNum!,
                            title: data.title ?? "",
                            description: data.description!,
                            price: data.totalPrice!,
                            currency:
                                controller.appServices.userCurrencyCode.value,
                            orderStatus: data.orderStatus!,
                          ),
                          const SizedBox(height: 12),
                          OrderImagesPart(
                            images: data.productImages!,
                          ),
                          const SizedBox(height: 18),
                          if (data.orderStatus! ==
                                  OrderStatus.waitingforDriver ||
                              data.orderStatus! == OrderStatus.pending ||
                              data.orderStatus! == OrderStatus.pendingPayment)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: GlobalButton(
                                onTap: () =>
                                    controller.cancelOrders(data.orderNum!),
                                text: 'Cancel Order'.tr,
                                color: Get.theme.colorScheme.error,
                                width: Get.width,
                              ),
                            ),
                          const SizedBox(height: 15),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: GlobalButton(
                              onTap: () =>
                                  controller.regenerateCode(data.orderNum!),
                              text: 'Get Order Code'.tr,
                              color: Constants.accent,
                              width: Get.width,
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
