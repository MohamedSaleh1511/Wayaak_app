import 'dart:io';

import 'package:get/get.dart';
import 'package:wayaak/app/data/models/add_order_model/add_order_model.dart';
import 'package:wayaak/app/data/models/countries_model/countries_model.dart';
import 'package:wayaak/app/data/models/delivery_cost_model/delivery_cost_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/order_accept_model/order_accept_model.dart';
import 'package:wayaak/app/data/models/payment_method_model/payment_method_model.dart';
import 'package:wayaak/app/data/models/vehicles_category_model/vehicles_category_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class AddOrderProviders extends ApiProvider {
  // NOTE :- Get Payment Methods
  Future<Map<String, dynamic>?> getPaymentMethods() async {
    Response res = await get('api/payment_methods', headers: {
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
            : PaymentMethodModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Vehicles
  Future<Map<String, dynamic>?> getVehicles() async {
    Response res = await get('api/vehicle_categories', headers: {
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
            : VehiclesCategoryModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Countries
  Future<Map<String, dynamic>?> getCountries() async {
    Response res = await get('api/countries', headers: {
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
            : CountriesModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Add Order
  Future<Map<String, dynamic>?> postAddOrder({
    required String vehicleId,
    required String description,
    required List<File> productImages,
    required String currentLatitude,
    required String currentLongitude,
    required String currentTitle,
    required String destinationLatitude,
    required String destinationLongitude,
    required String destinationTitle,
    required int countryId,
    required String paymentMethodId,
    required String couponCode,
  }) async {
    Get.log("vehicle_category_id ::==>> $vehicleId");
    Get.log("desc ::==>> $description");
    Get.log(
        "ProductImages ::==>> ${productImages.map((e) => e.path.split('/').last).toList()}");
    Get.log("current_latitude ::==>> $currentLatitude");
    Get.log("current_longitude ::==>> $currentLongitude");
    Get.log("destination_latitude ::==>> $destinationLatitude");
    Get.log("destination_longitude ::==>> $destinationLongitude");
    Get.log("countryId ::==>> $countryId");
    Get.log("paymentId ::==>> $paymentMethodId");
    Get.log("couponCode ::==>> $couponCode");
    FormData formData = FormData({
      'vehicle_category_id': vehicleId,
      'description': description,
      'product_images[]': productImages.isEmpty
          ? []
          : List.generate(
              productImages.length,
              (index) => MultipartFile(
                productImages[index],
                filename: productImages[index].path.split('/').last,
              ),
            ),
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'current_title': currentTitle,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'destination_title': destinationTitle,
      'country_id': countryId,
      'payment_method_id': paymentMethodId,
      'coupon_code': couponCode,
    });

    Response res = await post('api/create_order', formData, headers: {
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
            : AddOrderModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Add Order
  Future<Map<String, dynamic>?> postCancelOrder({String? orderId}) async {
    Response res = await post('api/cancel_order/$orderId', {}, headers: {
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
            : AddOrderModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Accept Order
  Future<Map<String, dynamic>?> acceptOffer(
      {String? orderNum, int? offerId}) async {
    Response res = await get('api/accept_offer/$orderNum/$offerId', headers: {
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
            : OrderAcceptModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Decline Order
  Future<Map<String, dynamic>?> declineOffer(
      {String? orderNum, int? offerId}) async {
    Response res = await get('api/decline_offer/$orderNum/$offerId', headers: {
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
            : OrderAcceptModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Decline Order
  Future<Map<String, dynamic>?> getMinMaxCost({
    double? distance,
    int? urgent,
    int? countryId,
    int? vehicleCategoryId,
    String? type,
  }) async {
    Response res = await post('api/calculate_min_max', {
      'distance': distance,
      'urgent': urgent,
      'country_id': countryId,
      'vehicle_category_id': vehicleCategoryId,
      'type': type,
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
            : DeliveryCostModel.fromJson(res.body),
      };
    }
  }
}
