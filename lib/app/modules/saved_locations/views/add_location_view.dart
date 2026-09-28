import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/saved_locations/controllers/saved_locations_controller.dart';
import 'package:wayaak/app/modules/saved_locations/widgets/map_sheet.dart';

class AddLocationView extends GetView<SavedLocationsController> {
  const AddLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.titleController.text = '';
        controller.locationController.text = '';
      },
      child: Scaffold(
        appBar: GlobalAppbar(
          title:
              (controller.addEditLocationType.value == AddEditLocationType.add)
                  ? 'Add Location'.tr
                  : 'Edit Location'.tr,
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                'world-tour'.iconColored(size: Get.width * 0.9),
                Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlobalTextField(
                        hintText: 'Location Title'.tr,
                        inputType: TextInputType.name,
                        controller: controller.titleController,
                        prefixIcon: 'location',
                        onSaved: (p0) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please enter location description'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 5),
                      GlobalTextField(
                        controller: controller.locationController,
                        hintText: 'Location from map'.tr,
                        inputType: TextInputType.name,
                        onTap: () {
                          Get.to(() => const MapSheet());
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please add location on map'.tr;
                          } else {
                            return null;
                          }
                        },
                        prefixIcon: 'location',
                        suffixText: 'Add'.tr,
                      ),
                    ],
                  ).decorate(padding: 8),
                ),
                const SizedBox(height: 18),
                GlobalButton(
                  onTap: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.formKey.currentState!.save();
                      if (controller.addEditLocationType.value ==
                          AddEditLocationType.add) {
                        controller.addSavedLocations();
                      } else {
                        controller.editSavedLocations(Get.arguments);
                      }
                    }
                  },
                  text: (controller.addEditLocationType.value ==
                          AddEditLocationType.add)
                      ? 'Save'.tr
                      : 'Edit'.tr,
                  width: Get.width * 0.4,
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
