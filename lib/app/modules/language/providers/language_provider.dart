import 'package:get/get.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class LanguageProviders extends ApiProvider {
  // NOTE :- Post Change Language
  Future<Map<String, dynamic>?> getChangeLanguage(String? language) async {
    Response res = await get('api/change_language/$language', headers: {
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
        'data': NoDataResponseModel.fromJson(res.body),
      };
    }
  }
}
