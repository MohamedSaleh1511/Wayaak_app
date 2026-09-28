import 'package:get/get.dart';
import 'package:wayaak/app/data/models/chat_messages_model/chat_messages_model.dart';
import 'package:wayaak/app/data/models/delivery_cost_model/delivery_cost_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/offers_model/offers_model.dart';
import 'package:wayaak/app/data/models/order_details_model/order_details_model.dart';
import 'package:wayaak/app/data/models/orders_model/orders_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

import '../../../data/models/countries_model/countries_model.dart';

class OrdersProviders extends ApiProvider {
  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> getLatestOrders() async {
    Response res = await get('api/limit_latest_orders', headers: {
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
            : OrdersModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Order details
  Future<Map<String, dynamic>?> getOrderDetails({String? orderNum}) async {
    Response res = await get('api/order/$orderNum', headers: {
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
            : OrderDetailsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get All Orders
  Future<Map<String, dynamic>?> getAllOrders() async {
    Response res = await get('api/all_orders', headers: {
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
            : OrdersModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Cancel Order
  Future<Map<String, dynamic>?> postCancelOrder({String? orderNum}) async {
    Response res = await post('api/cancel_order/$orderNum', {}, headers: {
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
            ? NoDataResponseModel.fromJson(res.body)
            : NoDataResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Cancel Order
  Future<Map<String, dynamic>?> getChatWithDriverId(int driverId) async {
    Response res = await get('api/get_chat/$driverId', headers: {
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
        'data': (res.statusCode == 404)
            ? NoDataResponseModel.fromJson(res.body)
            : ChatMessagesModel.fromJson(res.body),
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

  // NOTE :- Get Order Offers
  Future<Map<String, dynamic>?> getRegenerateCode(
      {required String orderNum}) async {
    Response res = await get('api/regenerate_code/$orderNum', headers: {
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
      if(res.statusCode== 200){
        return {
          'code': res.statusCode!,
          'data': (res.statusCode != 200)
              ? GlobalResponseModel.fromJson(res.body)
              : res.body['data'],
        };
      }else{
        return null;
      }

    }
  }

  // NOTE :- Get Decline Order
  Future<Map<String, dynamic>?> getOrderOffers(
      {required String orderNum}) async {
    Response res = await get('api/get_offers/$orderNum', headers: {
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
            : OffersModel.fromJson(res.body),
      };
    }
  }
}
