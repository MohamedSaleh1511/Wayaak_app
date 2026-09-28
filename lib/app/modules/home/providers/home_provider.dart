import 'package:get/get.dart';
import 'package:wayaak/app/data/models/banners_model/banners_model.dart';
import 'package:wayaak/app/data/models/current_shipments_model/current_shipments_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/orders_model/orders_model.dart';
import 'package:wayaak/app/data/models/review_response_model/review_response_model.dart';
import 'package:wayaak/app/data/models/update_transaction_model/update_transaction_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class HomeProviders extends ApiProvider {
  // NOTE :- Get Banners
  Future<Map<String, dynamic>?> banners() async {
    Response res = await get('api/banners', headers: {
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
            : BannersModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Current Shipment
  Future<Map<String, dynamic>?> getCurrentShipment() async {
    Response res = await get('api/current_shipment', headers: {
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
            : CurrentShipmentsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Decline Order
  Future<Map<String, dynamic>?> updateTransaction(
      {String? orderNum, String? referenceNum}) async {
    Response res = await post('api/update_transaction/$orderNum', {
      'referenceNumber': referenceNum,
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
            : UpdateTransactionModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Decline Order
  Future<Map<String, dynamic>?> rateDriver(
      {int? driverId, String? comment, double? rate}) async {
    Response res = await post('api/add_review_driver', {
      'driver_id': driverId,
      'comment': comment,
      'rate': rate
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
            : ReviewResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Decline Order
  Future<Map<String, dynamic>?> orderStatus({int? orderNum}) async {
    Response res = await get('api/order_status/$orderNum', headers: {
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
        'data': res.body,
      };
    }
  }

  // NOTE :- Get Order details
  Future<Map<String, dynamic>?> searchOrders(
      {String? orderNum, String? orderTitle}) async {
    Response res = await post('api/all_orders', {
      'order_num': orderNum,
      'title': orderTitle,
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
            : OrdersModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Log out
  Future<Map<String, dynamic>?> postLogout() async {
    Response res = await post('api/logout', {}, headers: {
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

  // NOTE :- Get Delete Account
  Future<Map<String, dynamic>?> deleteAccount() async {
    Response res = await get('api/delete_account', headers: {
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
}
