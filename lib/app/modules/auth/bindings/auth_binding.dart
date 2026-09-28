import 'package:get/get.dart';
import 'package:wayaak/app/modules/auth/providers/auth_providers.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProviders>(() => AuthProviders());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
