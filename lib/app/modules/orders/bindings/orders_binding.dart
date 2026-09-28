import 'package:get/get.dart';
import 'package:wayaak/app/modules/orders/providers/orders_provider.dart';

import '../controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersProviders>(() => OrdersProviders());
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
