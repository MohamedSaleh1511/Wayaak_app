import 'package:get/get.dart';
import 'package:wayaak/app/data/models/coupons_model/coupons_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class CouponsProviders extends ApiProvider {
  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> getCoupons() async {
    Response res = await get('api/all_coupons', headers: {
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
            : CouponsModel.fromJson(res.body),
      };
    }
  }
}
