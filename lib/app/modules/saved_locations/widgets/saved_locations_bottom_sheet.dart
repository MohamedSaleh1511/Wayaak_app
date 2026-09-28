import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/saved_locations/controllers/saved_locations_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class SavedLocationsBottomSheet extends StatelessWidget {
  final int locationType; // 0 for current, 1 for destination
  final VoidCallback? onLocationSelected; // Callback to close parent screen
  
  const SavedLocationsBottomSheet({
    super.key, 
    required this.locationType,
    this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final savedLocationsController = Get.find<SavedLocationsController>();
    final addOrderController = Get.find<AddOrderController>();

    // Load saved locations when bottom sheet opens
    savedLocationsController.getSavedLocations();

    return Container(
      height: Get.height * 0.7,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'Saved Locations'.tr.subtitle(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: 'Close'.iconColored(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (savedLocationsController.isLocationsLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (savedLocationsController.savedLocationsModel.value.data ==
                      null ||
                  savedLocationsController
                      .savedLocationsModel.value.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      'No saved locations'.tr.body(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          savedLocationsController.addEditLocationType.value =
                              AddEditLocationType.add;
                          // Use a small delay to ensure bottom sheet is fully closed
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Get.toNamed(Routes.addLocation);
                          });
                        },
                        child: 'Add New Location'.tr.button(),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount:
                    savedLocationsController.savedLocationsModel.value.data!
                            .length +
                        1, // +1 for "Add New Location" button
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  // Last item is "Add New Location" button
                  if (index ==
                      savedLocationsController
                          .savedLocationsModel.value.data!.length) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        savedLocationsController.addEditLocationType.value =
                            AddEditLocationType.add;
                        // Use a small delay to ensure bottom sheet is fully closed
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Get.toNamed(Routes.addLocation);
                        });
                      },
                      icon: 'Plus'.iconColored(color: Colors.white),
                      label: 'Add New Location'.tr.button(color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  }

                  final location =
                      savedLocationsController.savedLocationsModel.value
                          .data![index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      // Update the appropriate location based on type
                      if (locationType == 0) {
                        addOrderController.currentLocation.value = location;
                      } else {
                        addOrderController.destinationLocation.value = location;
                      }
                      
                      // Close the bottom sheet
                      Navigator.of(context).pop();
                      
                      // Call the callback to close parent map picker
                      if (onLocationSelected != null) {
                        onLocationSelected!();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          'location'.iconColored(color: Get.theme.primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (location.title ?? '')
                                    .bodyMedium(color: Colors.black),
                                if (location.latitude != null &&
                                    location.longitude != null)
                                  '(${double.parse(location.latitude!).toStringAsFixed(4)}, ${double.parse(location.longitude!).toStringAsFixed(4)})'
                                      .caption(color: Colors.grey),
                              ],
                            ),
                          ),
                          'arrow-right'.iconColored(),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}