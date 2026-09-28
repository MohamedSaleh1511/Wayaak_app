import 'package:get/get.dart';
import 'package:wayaak/app/modules/reviews/providers/reviews_provider.dart';

import '../controllers/reviews_controller.dart';

class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewsController>(() => ReviewsController());
    Get.lazyPut<ReviewsProviders>(() => ReviewsProviders());
  }
}
