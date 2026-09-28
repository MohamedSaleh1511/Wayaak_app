import 'dart:io';
import 'package:get/get.dart';
import 'package:wayaak/app/data/models/balance_model/balance_model.dart';
import 'package:wayaak/app/data/models/charge_wallet_model/charge_wallet_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/profile_model/profile_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class ProfileProviders extends ApiProvider {
  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> getProfile() async {
    Response res = await get('api/profile', headers: {
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
            : ProfileModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Reset Password
  Future<Map<String, dynamic>?> postUpdatePassword(
    String? oldPassword,
    String? password,
    String? passwordConfirmation,
  ) async {
    Get.log(oldPassword!);
    Get.log(password!);
    Get.log(passwordConfirmation!);
    Response res = await post('api/update_password', {
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
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
        'data': GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Update Profile
  Future<Map<String, dynamic>?> postUpdateProfile({
    String? name,
    String? email,
    String? gender,
    String? birthDate,
    File? avatar,
    String? password,
    String? passwordConfirm,
  }) async {
    Response res = await post(
        'api/update_profile',
        FormData({
          'name': name,
          'email': email,
          'gender': gender,
          'birth_date': birthDate,
          'avatar': avatar!.path.isEmpty
              ? null
              : MultipartFile(avatar, filename: avatar.path.split('/').last),
          'password': password,
          'password_confirmation': passwordConfirm,
        }),
        headers: {
          // 'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          'Authorization':
              'Bearer ${Get.find<AppServices>().accessToken.value}',
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
            : ProfileModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Account Balance
  Future<Map<String, dynamic>?> getAccountBalance() async {
    Response res = await get('api/balance', headers: {
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
        'data': (res.statusCode == 200)
            ? BalanceModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Charge wallet
  Future<Map<String, dynamic>?> postChargeWallet(
      double balance, String referenceNumber) async {
    Response res = await post('api/charge_wallet', {
      'balance': balance,
      'referenceNumber': referenceNumber,
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
        'data': (res.statusCode == 200)
            ? ChargeWalletModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }
}
