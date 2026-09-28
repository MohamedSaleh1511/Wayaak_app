import 'package:get/get.dart';
import 'package:wayaak/app/data/models/add_review_model/add_review_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/reviews_model/reviews_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class ReviewsProviders extends ApiProvider {
  // NOTE :- Get All Reviews
  Future<Map<String, dynamic>?> getAllReviews() async {
    Response res = await get('api/reviews', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : ReviewsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Add Review
  Future<Map<String, dynamic>?> postAddReview({
    required String driverId,
    String? comment,
    required double rate,
  }) async {
    Response res = await post('api/add_review_driver', {
      'driver_id': driverId,
      'comment': comment,
      'rate': rate,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : AddReviewModel.fromJson(res.body),
      };
    }
  }
}
