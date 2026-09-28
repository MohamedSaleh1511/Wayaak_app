import 'package:get/get.dart';
import 'package:wayaak/app/modules/coupons/controllers/coupons_controller.dart';
import 'package:wayaak/app/modules/coupons/providers/coupons_provider.dart';

class CouponsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CouponsController>(() => CouponsController());
    Get.lazyPut<CouponsProviders>(() => CouponsProviders());
  }
}
