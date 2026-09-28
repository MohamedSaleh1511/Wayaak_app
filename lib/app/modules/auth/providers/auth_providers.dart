import 'package:get/get.dart';
import 'package:wayaak/app/data/models/auth/login_response_model/login_response_model.dart';
import 'package:wayaak/app/data/models/auth/signup_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';

class AuthProviders extends ApiProvider {
  // NOTE :- Post Register
  Future<Map<String, dynamic>?> postRegister(SignupRequestModel data) async {
    Response res = await post('api/register', FormData(data.toJson()));
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      final isSuccessful = res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300;
      return {
        'code': res.statusCode!,
        'data': isSuccessful
            ? NoDataResponseModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Login
  Future<Map<String, dynamic>?> postLogin(
      String? phone, String? password, String? fcmToken) async {
    Response res = await post('api/login', {
      'phone': phone,
      'password': password,
      'fcm_token': fcmToken,
      'language': Get.locale == null ? 'en' : Get.locale!.languageCode,
    }, headers: {
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
        'data': (res.statusCode == 400)
            ? GlobalResponseModel.fromJson(res.body)
            : (res.statusCode == 403 || res.statusCode == 401)
                ? NoDataResponseModel.fromJson(res.body)
                : (res.statusCode == 200)
                    ? LoginResponseModel.fromJson(res.body)
                    : res.body,
      };
    }
  }

  // NOTE :- Post Verification Phone
  Future<Map<String, dynamic>?> postVerify(
      String? phone, String? loginCode) async {
    Response res = await post(
        'api/register/verify_phone', {'phone': phone, 'login_code': loginCode});
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 200)
            ? LoginResponseModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Forget Password
  Future<NoDataResponseModel?> getForgetPassword(String? phone) async {
    Response res = await get('api/forgot_password?phone=$phone');
    if (res.status.isServerError || res.status.connectionError) {
      return null;
    } else {
      Get.log(res.statusCode.toString());
      return NoDataResponseModel.fromJson(res.body);
    }
  }

  // NOTE :- Post Check Reset Code
  Future<Map<String, dynamic>?> postCheckResetCode(
      String? phone, String? loginCode) async {
    Response res = await post('api/check_reset_code',
        {'phone': phone, 'reset_password_code': loginCode});
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Reset Password
  Future<Map<String, dynamic>?> postResetPassword(
    String? phone,
    String? password,
    String? passwordConfirmation,
  ) async {
    Response res = await post('api/reset_password', {
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Reset Password
  Future<Map<String, dynamic>?> postResendOtp(String? phone) async {
    Response res = await post('api/resend_otp', {'phone': phone});
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

  // NOTE :- Post Social Register
  Future<Map<String, dynamic>?> postSocialRegister({
    String? name,
    String? email,
    String? phone,
    String? socialMediaId,
    String? provider,
  }) async {
    Response res = await post('api/social/register', {
      'name': name,
      'email': email,
      'phone': phone,
      'social_media_id': socialMediaId,
      'provider': provider,
      'language': Get.locale == null ? 'en' : Get.locale!.languageCode,
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
            : NoDataResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Social Register
  Future<Map<String, dynamic>?> postSocialLogin({
    String? socialMediaId,
    String? provider,
    String? fcmToken,
  }) async {
    Response res = await post('api/social/login', {
      'social_media_id': socialMediaId,
      'provider': provider,
      "fcm_token": fcmToken,
      'language': Get.locale == null ? 'en' : Get.locale!.languageCode,
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 400)
            ? GlobalResponseModel.fromJson(res.body)
            : (res.statusCode == 403 || res.statusCode == 401)
                ? NoDataResponseModel.fromJson(res.body)
                : LoginResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Login As Guest
  Future<Map<String, dynamic>?> postLoginAsGuest() async {
    Response res = await post('api/login_as_guest', {});
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 400)
            ? GlobalResponseModel.fromJson(res.body)
            : NoDataResponseModel.fromJson(res.body),
      };
    }
  }
}
