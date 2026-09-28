import 'package:get/get.dart';
import 'package:wayaak/app/modules/saved_locations/providers/saved_locations_provider.dart';

import '../controllers/saved_locations_controller.dart';

class SavedLocationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedLocationsProviders>(() => SavedLocationsProviders());
    Get.lazyPut<SavedLocationsController>(() => SavedLocationsController());
  }
}
