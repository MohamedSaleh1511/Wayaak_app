import 'package:get/get.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/notifications_model/notifications_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class NotificationsProviders extends ApiProvider {
  // NOTE :- Get Payment Methods
  Future<Map<String, dynamic>?> getNotifications() async {
    Response res = await get('api/notifications', headers: {
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
            : NotificationsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Payment Methods
  Future<Map<String, dynamic>?> clearNotifications() async {
    Response res =
        await post('api/notifications/clear_notifications', {}, headers: {
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
            : NoDataResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Payment Methods
  Future<int?> markAsRead(String id) async {
    Response res = await post('api/notifications/mark_as_read', {
      "notification_id": id,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError || res.status.connectionError) {
      return null;
    } else {
      Get.log(res.statusCode.toString());
      return res.statusCode!;
    }
  }
}
