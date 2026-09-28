import 'package:get/get.dart';
import 'package:wayaak/app/data/models/contact_us_model/contact_us_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/static_pages_model/static_pages_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class StaticPagesProviders extends ApiProvider {
  // NOTE :- Get Privacy Policy
  Future<Map<String, dynamic>?> getPrivacyPolicy() async {
    Response res =
        await get('api/privacy/${Get.locale!.languageCode}', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
            : StaticPagesModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Terms & Conditions
  Future<Map<String, dynamic>?> getTermsAndConditions() async {
    Response res = await get('api/terms/${Get.locale!.languageCode}', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
            : StaticPagesModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get About Us
  Future<Map<String, dynamic>?> getAboutUs() async {
    Response res =
        await get('api/about_us/${Get.locale!.languageCode}', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
            : StaticPagesModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Contact us
  Future<Map<String, dynamic>?> contactUs({
    required String name,
    required String email,
    required String message,
  }) async {
    Response res = await post('api/send_contact_msg', {
      'name': name,
      'email': email,
      'message': message
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
            : ContactUsModel.fromJson(res.body),
      };
    }
  }
}
