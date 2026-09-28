import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/add_order_model/add_order_model.dart';
import 'package:wayaak/app/data/models/countries_model/countries_model.dart';
import 'package:wayaak/app/data/models/countries_model/datum.dart';
import 'package:wayaak/app/data/models/coupons_model/coupon.dart';
import 'package:wayaak/app/data/models/delivery_cost_model/delivery_cost_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/order_accept_model/order_accept_model.dart';
import 'package:wayaak/app/data/models/payment_method_model/datum.dart';
import 'package:wayaak/app/data/models/payment_method_model/payment_method_model.dart';
import 'package:wayaak/app/data/models/saved_locations_model/datum.dart';
import 'package:wayaak/app/data/models/vehicles_category_model/datum.dart';
import 'package:wayaak/app/data/models/vehicles_category_model/vehicles_category_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/data/services/socket_service.dart';
import 'package:wayaak/app/modules/add_order/providers/add_order_provider.dart';
import 'package:wayaak/app/modules/coupons/controllers/coupons_controller.dart';
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class AddOrderController extends GetxController {
  final AddOrderProviders provider = Get.find<AddOrderProviders>();
  final SocketServices socketServices = Get.find<SocketServices>();
  final AppServices appServices = Get.find<AppServices>();
  final OrdersController ordersController = Get.find<OrdersController>();
  final CouponsController couponsController = Get.find<CouponsController>();
  final ExpansibleController importanceController = ExpansibleController();
  final ExpansibleController vehicleController = ExpansibleController();
  final GlobalKey<FormState> addOrderFormKey = GlobalKey<FormState>();
  Rx<Set<Polyline>> polylines = Rx({});
  LatLng loc1 = const LatLng(30.210206, 31.357403);
  LatLng loc2 = const LatLng(30.214859, 31.365583);

  Map<int, OrderStatus> orderStatuses = {
    1: OrderStatus.pending,
    2: OrderStatus.waitingforDriver,
    3: OrderStatus.driverAccepted,
    4: OrderStatus.delivered,
    5: OrderStatus.cancelled,
  };

  RxBool isPaymentMethodsLoading = false.obs;
  RxList<PaymentMethodDatum> paymentMethodsList = <PaymentMethodDatum>[].obs;
  getPaymentMethods() async {
    isPaymentMethodsLoading.value = true;
    Map<String, dynamic>? data = await provider.getPaymentMethods();
    isPaymentMethodsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          paymentMethodsList.value = (data['data'] as PaymentMethodModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting payments');
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  RxBool isVehiclesLoading = false.obs;
  RxList<VehiclesDatum> vehiclesList = <VehiclesDatum>[].obs;
  getVehicles() async {
    isVehiclesLoading.value = true;
    Map<String, dynamic>? data = await provider.getVehicles();
    isVehiclesLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          vehiclesList.value = (data['data'] as VehiclesCategoryModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting vehicles');
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  RxBool isCountriesLoading = false.obs;
  RxList<CountryDatum> countriesList = <CountryDatum>[].obs;
  getCountriesList() async {
    isCountriesLoading.value = true;
    Map<String, dynamic>? data = await provider.getCountries();
    isCountriesLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.log("Getting all the countries");
          countriesList.value = (data['data'] as CountriesModel).data!;
        } else {
          // Ui.errorGetBar(message: 'error occured on getting countries');
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  Rx<String> vehicleId = '1'.obs;
  Rx<VehiclesDatum> vehicleData = VehiclesDatum().obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Rx<LocationDatum> currentLocation = LocationDatum().obs;
  Rx<LocationDatum> destinationLocation = LocationDatum().obs;
  Rx<Coupon> coupon = Coupon().obs;
  Rx<OrderImportance> importance = OrderImportance.regular.obs;
  RxList<File> productImages = <File>[].obs;
  Rx<AddOrderModel> addOrderModel = AddOrderModel().obs;
  addOrder() async {
    try {
      print('GGGGGGGGGGGGGGGG');
      print(countriesList
          .where((e) => e.code! == appServices.userCountryCode.value)
          .isEmpty
          ? 1
          : countriesList
          .where((e) => e.code! == appServices.userCountryCode.value)
          .first
          .id!);
      Ui.loadingDialog();
      Map<String, dynamic>? data = await provider.postAddOrder(
        vehicleId: vehicleId.value,
        description: descriptionController.text,
        couponCode: coupon.value.code ?? '',
        currentLatitude: currentLocation.value.latitude!,
        currentLongitude: currentLocation.value.longitude!,
        currentTitle: currentLocation.value.title!,
        destinationLatitude: destinationLocation.value.latitude!,
        destinationLongitude: destinationLocation.value.longitude!,
        destinationTitle: destinationLocation.value.title!,
        countryId: countriesList
                .where((e) => e.code! == appServices.userCountryCode.value)
                .isEmpty
            ? 1
            : countriesList
                .where((e) => e.code! == appServices.userCountryCode.value)
                .first
                .id!,
        paymentMethodId: appServices.paymentMethod.value,
        productImages: productImages,
      );
      Get.back();
      if (data != null) {
        if (data.containsKey('error')) {
          Ui.errorGetBar(
              message: 'Connection Error, Check your network please'.tr);
        } else {
          if (data['code'] == 200) {
            addOrderModel.value = data['data'] as AddOrderModel;
            appServices.orderId.value =
                addOrderModel.value.data!.id!.toString();
            appServices.orderNum.value =
                addOrderModel.value.data!.orderNum!.toString();
            socketServices.offersList.value = [];
            socketServices.checkBroadcastAuth(
                "private-order-offers.${addOrderModel.value.data!.orderNum}");
            Get.toNamed(Routes.offers,
                arguments: [minCost.value, maxCost.value, urgent.value]);
          } else {
            GlobalResponseModel model = data['data'] as GlobalResponseModel;
            Ui.errorGetBar(message: model.message!);
          }
        }
      } else {
        Ui.errorGetBar(message: 'Internal Server Error'.tr);
      }
    } catch (e) {
      Ui.errorGetBar(message: 'error $e');
    }
  }

  Rx<OrderAcceptModel> orderAcceptModel = OrderAcceptModel().obs;
  acceptRequest(int offerId, double price) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.acceptOffer(
      orderNum: appServices.orderNum.value,
      offerId: offerId,
    );
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          orderAcceptModel.value = data['data'] as OrderAcceptModel;

          socketServices.checkBroadcastAuth(
              "private-user-location.${appServices.userId.value}");

          ordersController.orderDetails(appServices.orderNum.value);
          Get.back();
          Get.offNamed(Routes.orderDetails, arguments: 'track');
          ordersController.getLastOrders();
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured while accepting request');
    }
  }

  Rx<OrderAcceptModel> orderDeclineModel = OrderAcceptModel().obs;
  declineRequest(int offerId) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.declineOffer(
      orderNum: appServices.orderNum.value,
      offerId: offerId,
    );
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          orderDeclineModel.value = data['data'] as OrderAcceptModel;
          socketServices.offersList.removeWhere((v) => v.id! == offerId);
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured while declining request');
    }
  }

  RxString minCost = ''.obs;
  RxString maxCost = ''.obs;
  RxString urgent = ''.obs;
  Rx<DeliveryCostModel> deliveryCostModel = DeliveryCostModel().obs;

  Future<bool> getMinMaxDeliveryCost() async {
    Ui.loadingDialog();
    Get.log(
        "User Type :: ${appServices.userType.value.toJson().toLowerCase()}");

    Map<String, dynamic>? data = await provider.getMinMaxCost(
      distance: double.parse(appServices
          .calculateDistance(
            currentLoc: LatLng(
              double.parse(currentLocation.value.latitude!),
              double.parse(currentLocation.value.longitude!),
            ),
            destination: LatLng(
              double.parse(destinationLocation.value.latitude!),
              double.parse(destinationLocation.value.longitude!),
            ),
          )
          .toStringAsFixed(2)),
      urgent: importance.value.getId(),
      countryId: countriesList
              .where((e) =>
                  e.code! == appServices.userCountryCode.value.toLowerCase() ||
                  e.code! == appServices.userCountryCode.value)
              .isEmpty
          ? 24
          : countriesList
              .where((e) =>
                  e.code! == appServices.userCountryCode.value.toLowerCase() ||
                  e.code! == appServices.userCountryCode.value)
              .first
              .id,
      vehicleCategoryId: int.parse(vehicleId.value),
      type: appServices.userType.value.toJson().toLowerCase(),
    );
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
        return false;
      } else {
        if (data['code'] == 200) {
          deliveryCostModel.value = data['data'] as DeliveryCostModel;
          minCost.value = (data['data'] as DeliveryCostModel).data!.minCost!;
          maxCost.value = (data['data'] as DeliveryCostModel).data!.maxCost!;
          urgent.value = (data['data'] as DeliveryCostModel).data!.urgent!;
          Get.log(
              "Min Max Cost :::: ${(data['data'] as DeliveryCostModel).data!.minCost!}");
          Get.log(
              "Min Max Cost :::: ${(data['data'] as DeliveryCostModel).data!.maxCost!}");
          Get.log("Min Max Cost :: $minCost");
          Get.log("Min Max Cost :: $maxCost");
          return true;
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
          return false;
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured while getting delivery cost');
      return false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    getPaymentMethods();
    getVehicles();
    getCountriesList();
  }

  /// Helper method to create LocationDatum from title and coordinates
  LocationDatum createLocationDatum({
    required String title,
    required double latitude,
    required double longitude,
    int? id,
  }) {
    return LocationDatum(
      id: id,
      title: title,
      latitude: latitude.toString(),
      longitude: longitude.toString(),
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
