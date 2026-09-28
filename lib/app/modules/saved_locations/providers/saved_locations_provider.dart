import 'package:get/get.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/new_location_model/new_location_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/saved_locations_model/saved_locations_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class SavedLocationsProviders extends ApiProvider {
  // NOTE :- GET Saved Locations
  Future<Map<String, dynamic>?> getSavedLocations() async {
    Response res = await get('api/saved_locations', headers: {
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
            : SavedLocationsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- POST add new location
  Future<Map<String, dynamic>?> postAddNewLocation(
      String title, double latitude, double longitude) async {
    Response res = await post('api/add_location', {
      'title': title,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
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
            : NewLocationModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- POST edit location
  Future<Map<String, dynamic>?> postEditLocation({
    required String id,
    required String title,
    required double latitude,
    required double longitude,
  }) async {
    Response res = await post('api/edit_location/$id', {
      'title': title,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
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
            : NewLocationModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- POST edit location
  Future<Map<String, dynamic>?> postDeleteLocation({required String id}) async {
    Response res = await post('api/delete_location/$id', {}, headers: {
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
            ? NoDataResponseModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }
}
