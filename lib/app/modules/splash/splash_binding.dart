import 'package:get/get.dart';
// import 'package:qor3a/app/data/providers/splash_provider.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<SplashProviders>(SplashProviders());
    Get.put<SplashController>(SplashController());
  }
}
