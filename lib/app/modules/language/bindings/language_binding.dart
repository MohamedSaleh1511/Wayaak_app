import 'package:get/get.dart';
import 'package:wayaak/app/modules/language/providers/language_provider.dart';

import '../controllers/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(() => LanguageController());
    Get.lazyPut<LanguageProviders>(() => LanguageProviders());
  }
}
