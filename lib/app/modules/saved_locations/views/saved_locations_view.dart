import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/profile/widgets/logout_delete_dialog.dart';
import 'package:wayaak/app/modules/saved_locations/widgets/location_card_shimmer.dart';
import 'package:wayaak/app/routes/app_routes.dart';

import '../controllers/saved_locations_controller.dart';

class SavedLocationsView extends GetView<SavedLocationsController> {
  const SavedLocationsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.log("${Get.arguments}");
    return Scaffold(
      appBar: GlobalAppbar(title: 'Saved Locations'.tr),
      body: Obx(() {
        if (controller.isLocationsLoading.value) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemBuilder: (context, index) => const LocationCardShimmer(),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: 10,
          );
        } else {
          if (controller.savedLocationsModel.value.data == null) {
            return Center(child: 'No data found'.tr.body());
          } else {
            if (controller.savedLocationsModel.value.data!.isEmpty) {
              return Center(child: 'No data found'.tr.body());
            } else {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15)
                    .copyWith(bottom: 85),
                itemBuilder: (context, index) => InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    if (Get.arguments[0] == LocationsEntry.select &&
                        Get.arguments[1] == 0) {
                      controller.addOrderController.currentLocation.value =
                          controller.savedLocationsModel.value.data![index];

                      Get.back();
                    } else if (Get.arguments[0] == LocationsEntry.select &&
                        Get.arguments[1] == 1) {
                      controller.addOrderController.destinationLocation.value =
                          controller.savedLocationsModel.value.data![index];
                      Get.back();
                    }
                  },
                  child: Row(
                    children: [
                      'location'.iconColored(color: Colors.black),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (controller.savedLocationsModel.value.data![index]
                                        .title ??
                                    '')
                                .bodyMedium(color: Colors.black, maxLines: 2),
                            '(${double.parse(controller.savedLocationsModel.value.data![index].latitude ?? '').toStringAsFixed(4)},${double.parse(controller.savedLocationsModel.value.data![index].longitude ?? '').toStringAsFixed(4)})'
                                .caption(color: Constants.grey),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          controller.addEditLocationType.value =
                              AddEditLocationType.edit;
                          controller.titleController.text = controller
                              .savedLocationsModel.value.data![index].title!;
                          controller
                              .setManualLocation(
                            LatLng(
                              double.parse(controller.savedLocationsModel.value
                                  .data![index].latitude!),
                              double.parse(controller.savedLocationsModel.value
                                  .data![index].longitude!),
                            ),
                          )
                              .then((v) {
                            controller.latitude.value =
                                controller.currentLocation.value.latitude;
                            controller.longitude.value =
                                controller.currentLocation.value.longitude;
                            controller.locationController.text =
                                controller.getAddressName.value;
                          });

                          Get.toNamed(Routes.addLocation,
                              arguments: controller
                                  .savedLocationsModel.value.data![index].id!
                                  .toString());
                        },
                        icon: 'edit'.iconColored(),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () {
                          Get.dialog(
                            LogoutDeleteDialog(
                              title: "Delete Location".tr,
                              body:
                                  "Are you sure you want to delete this location"
                                      .tr,
                              buttonText: "Delete".tr,
                              buttonTap: () {
                                controller.deleteSavedLocations(controller
                                    .savedLocationsModel.value.data![index].id
                                    .toString());
                              },
                              primaryBtnColor: Constants.accent,
                              secondaryBtnColor: Constants.textColor,
                            ),
                          );
                        },
                        icon: 'delete'.iconColored(color: Colors.red),
                      ),
                    ],
                  ).decorate(padding: 12),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: controller.savedLocationsModel.value.data!.length,
              );
            }
          }
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.addEditLocationType.value = AddEditLocationType.add;
          Get.toNamed(Routes.addLocation);
        },
        label: 'Add Location'.tr.button(color: Colors.white),
        backgroundColor: Get.theme.primaryColor,
        icon: 'Plus'.iconColored(color: Colors.white),
      ),
    );
  }
}
