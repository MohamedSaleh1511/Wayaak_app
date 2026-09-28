import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/new_location_model/new_location_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/saved_locations_model/saved_locations_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/saved_locations/providers/saved_locations_provider.dart';

class SavedLocationsController extends GetxController {
  final AppServices appServices = Get.find<AppServices>();
  final SavedLocationsProviders provider = Get.find<SavedLocationsProviders>();
  final AddOrderController addOrderController = Get.find<AddOrderController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  RxBool isLocationsLoading = false.obs;
  Rx<SavedLocationsModel> savedLocationsModel = SavedLocationsModel().obs;
  getSavedLocations() async {
    isLocationsLoading.value = true;
    initializeLocation();
    Map<String, dynamic>? data = await provider.getSavedLocations();
    if (data != null) {
      isLocationsLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          savedLocationsModel.value = data['data'] as SavedLocationsModel;
          if (savedLocationsModel.value.data == null) {
            Ui.errorGetBar(message: savedLocationsModel.value.message!);
          }
        } else {
          Ui.errorGetBar(message: 'error occured on getting saved locations');
        }
      }
    } else {
      isLocationsLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting saved locations');
    }
  }

  addSavedLocations() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.postAddNewLocation(
      titleController.text,
      latitude.value,
      longitude.value,
    );
    if (data != null) {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          NewLocationModel model = data['data'] as NewLocationModel;
          Get.back();
          getSavedLocations();
          locationController.text = '';
          titleController.text = '';
          Ui.successGetBar(message: model.message!);
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'error occured on saving location');
    }
  }

  Rx<AddEditLocationType> addEditLocationType = AddEditLocationType.add.obs;
  editSavedLocations(String id) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.postEditLocation(
      id: id,
      title: titleController.text,
      latitude: latitude.value,
      longitude: longitude.value,
    );
    if (data != null) {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          NewLocationModel model = data['data'] as NewLocationModel;
          Get.back();
          getSavedLocations();
          locationController.text = '';
          titleController.text = '';
          Ui.successGetBar(message: model.message!);
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'error occured on editing location');
    }
  }

  deleteSavedLocations(String id) async {
    Get.back();
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.postDeleteLocation(id: id);
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          NoDataResponseModel model = data['data'] as NoDataResponseModel;
          getSavedLocations();
          Ui.successGetBar(message: model.message!);
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Cannot delete this location now');
    }
  }

  Rx<Position> currentLocation = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  ).obs;

  RxString getAddressName = ''.obs;

  Future<Position?> getCurrentLocation() async {
    try {
      var status = await Permission.location.status;
      if (status.isGranted) {
        return await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ));
      } else if (status.isDenied) {
        // Request permission if denied
        final result = await Permission.location.request();
        if (result.isGranted) {
          return await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ));
        } else {
          // Permission denied, return null instead of throwing error
          debugPrint('Location permission denied by user');
          return null;
        }
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied, return null
        debugPrint('Location permission permanently denied');
        return null;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  setCurrentLocation() async {
    Ui.loadingDialog();
    final location = await getCurrentLocation();
    if (location != null) {
      currentLocation.value = location;
      debugPrint('Current location : ${currentLocation.value}');
      await getPlaceMark();
    } else {
      debugPrint('Failed to get current location - permission denied');
      Ui.errorGetBar(
          message: 'Location permission is required to set your location'.tr);
    }
    Get.back();
  }

  initializeLocation() async {
    final location = await getCurrentLocation();
    if (location != null) {
      currentLocation.value = location;
    } else {
      // If location permission is denied, use default values
      debugPrint('Location permission denied, using default location');
      currentLocation.value = Position(
        longitude: 31.2357,
        latitude: 30.0444,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }
  }

  Future<void> setManualLocation(LatLng latlng) async {
    currentLocation.value = Position(
      longitude: latlng.longitude,
      latitude: latlng.latitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
    await getPlaceMark();
  }

  Future<void> getPlaceMark() async {
    List<Placemark> placemarks;
    try {
      placemarks = await placemarkFromCoordinates(
          currentLocation.value.latitude, currentLocation.value.longitude);

      getAddressName.value =
          '${placemarks[0].name} , ${placemarks[0].country} , ${placemarks[0].locality} , ${placemarks[0].street}';
      debugPrint('your Locaaaaaation :: $getAddressName');
    } catch (e) {
      placemarks = [
        const Placemark(locality: 'لا يوجد عنوان'),
      ];
    }
  }

  /// Formats address to show only street and town (locality/subLocality)
  /// without governorate (administrativeArea) and country
  Future<String> getFormattedAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        List<String> addressParts = [];

        // Add street if available
        if (placemark.street != null && placemark.street!.isNotEmpty) {
          addressParts.add(placemark.street!);
        }

        // Add subLocality (smaller area/town) if available, otherwise use locality
        if (placemark.subLocality != null &&
            placemark.subLocality!.isNotEmpty) {
          addressParts.add(placemark.subLocality!);
        } else if (placemark.locality != null &&
            placemark.locality!.isNotEmpty) {
          addressParts.add(placemark.locality!);
        }

        // If we still don't have a town, use subAdministrativeArea as fallback
        if (addressParts.length == 1 &&
            placemark.subAdministrativeArea != null &&
            placemark.subAdministrativeArea!.isNotEmpty) {
          addressParts.add(placemark.subAdministrativeArea!);
        }

        if (addressParts.isEmpty) {
          // Fallback to name if no street/town found
          return placemark.name ?? '';
        }

        return addressParts.join(', ');
      }
      return '';
    } catch (e) {
      debugPrint('Error formatting address: $e');
      return '';
    }
  }

  @override
  void onReady() {
    super.onReady();
    getSavedLocations();
  }

  @override
  void onClose() {
    locationController.dispose();
    titleController.dispose();
    super.onClose();
  }
}
