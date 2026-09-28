import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/reviews_model/reviews_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/reviews/providers/reviews_provider.dart';

class ReviewsController extends GetxController {
  final AppServices appServices = Get.find<AppServices>();
  final ReviewsProviders provider = Get.find<ReviewsProviders>();

  RxString driverId = ''.obs;
  RxString comment = ''.obs;
  RxDouble rate = 0.0.obs;

  RxBool isReviewsLoading = false.obs;
  Rx<ReviewsModel> reviewsModel = ReviewsModel().obs;
  getReviews() async {
    isReviewsLoading.value = true;
    Map<String, dynamic>? data = await provider.getAllReviews();
    isReviewsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          reviewsModel.value = data['data'] as ReviewsModel;
          if (reviewsModel.value.data == null) {
            Ui.errorGetBar(message: reviewsModel.value.message!);
          }
        } else if (data['code'] == 404) {
        } else {
          Ui.errorGetBar(message: 'error occured on getting reviews');
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  addReview() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.postAddReview(
      driverId: driverId.value,
      comment: comment.value,
      rate: rate.value,
    );
    Get.back();

    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.back();
          Ui.successGetBar(message: "Review add successfully");
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  @override
  void onReady() {
    super.onReady();
    getReviews();
  }
}
