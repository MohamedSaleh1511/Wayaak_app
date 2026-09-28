import 'package:get/get.dart';
import 'package:wayaak/app/modules/profits/providers/profit_providers.dart';

import '../controllers/profits_controller.dart';

class ProfitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfitProviders>(() => ProfitProviders());
    Get.lazyPut<ProfitsController>(() => ProfitsController());
  }
}
