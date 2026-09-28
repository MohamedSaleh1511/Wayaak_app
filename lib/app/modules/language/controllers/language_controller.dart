import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/language/providers/language_provider.dart';

class LanguageController extends GetxController {
  final LanguageProviders provider = Get.find<LanguageProviders>();
  final AppServices appServices = Get.find<AppServices>();
  Future<void> changeLang(String languageCode) async {
    Ui.loadingDialog();
    await provider.getChangeLanguage(languageCode);

    Get.back();
  }
}
