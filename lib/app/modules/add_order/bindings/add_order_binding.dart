import 'package:get/get.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/add_order/providers/add_order_provider.dart';

class AddOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddOrderProviders>(() => AddOrderProviders());
    Get.lazyPut<AddOrderController>(() => AddOrderController());
  }
}
