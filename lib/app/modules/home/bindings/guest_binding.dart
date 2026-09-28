import 'package:get/get.dart';
import 'package:wayaak/app/modules/static_pages/controllers/static_pages_controller.dart';
import 'package:wayaak/app/modules/static_pages/providers/static_pages_provider.dart';
import 'package:wayaak/app/modules/support/controllers/support_controller.dart';
import 'package:wayaak/app/modules/support/providers/support_providers.dart';

class GuestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaticPagesController>(() => StaticPagesController());
    Get.lazyPut<StaticPagesProviders>(() => StaticPagesProviders());
    Get.lazyPut<SupportController>(() => SupportController());
    Get.lazyPut<SupportProviders>(() => SupportProviders());
  }
}
