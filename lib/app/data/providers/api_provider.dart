import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import '../services/app_services.dart';

class ApiProvider extends GetConnect {
  final AppServices appServices = Get.put<AppServices>(AppServices());

  @override
  void onInit() {
    super.onInit();
    Get.log('tokkkkkkeeeeeeen :::: ${appServices.accessToken.value}');
    httpClient.baseUrl = Constants.baseUrl;
    httpClient.timeout = const Duration(seconds: 200);

    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers.addAll({
        'Authorization': 'Bearer ${appServices.accessToken.value}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      Get.log('token in header ${request.headers['Authorization']}');
      requestInterceptor(request);
      return request;
    });
    httpClient.addResponseModifier((request, response) async {
      Get.log('heaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaders');
      Get.log(request.headers.toString());
      Get.log(request.url.toString());
      Get.log(request.headers['Authorization'].toString());
      Get.log(response.body.toString());
      Get.log(request.method.toString());
      return response;
    });
  }

  Future<Request> requestInterceptor(Request request) async {
    debugPrint(request.headers.toString());
    Get.log(request.headers['Authorization'].toString());
    debugPrint(request.method);
    return request;
  }
}
