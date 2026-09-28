import 'package:get/get.dart';
import 'package:wayaak/app/modules/static_pages/controllers/static_pages_controller.dart';
import 'package:wayaak/app/modules/static_pages/providers/static_pages_provider.dart';

class StaticPagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaticPagesController>(() => StaticPagesController());
    Get.lazyPut<StaticPagesProviders>(() => StaticPagesProviders());
  }
}
