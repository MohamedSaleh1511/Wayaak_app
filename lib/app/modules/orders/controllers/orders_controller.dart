import 'dart:developer';
import 'package:wayaak/app/data/extensions/extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/chat_messages_model/chat_messages_model.dart';
import 'package:wayaak/app/data/models/chat_messages_model/messages.dart';
import 'package:wayaak/app/data/models/delivery_cost_model/delivery_cost_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/no_data_response_model.dart';
import 'package:wayaak/app/data/models/offers_model.dart';
import 'package:wayaak/app/data/models/offers_model/datum.dart';
import 'package:wayaak/app/data/models/offers_model/offers_model.dart';
import 'package:wayaak/app/data/models/order_details_model/order_details_model.dart';
import 'package:wayaak/app/data/models/orders_model/datum.dart';
import 'package:wayaak/app/data/models/orders_model/orders_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/data/services/socket_service.dart';
import 'package:wayaak/app/modules/orders/providers/orders_provider.dart';
import 'package:wayaak/app/routes/app_routes.dart';
import 'package:flutter/services.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/modules/notification/widgets/rating_dialog.dart';

import '../../../data/models/countries_model/countries_model.dart';
import '../../../data/models/countries_model/datum.dart';

class OrdersController extends GetxController {
  final OrdersProviders provider = Get.find<OrdersProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final SocketServices socketServices = Get.find<SocketServices>();
  Rx<Map<PolylineId, Polyline>> polylines = Rx(<PolylineId, Polyline>{});
  LatLng loc1 = const LatLng(30.210206, 31.357403);
  LatLng loc2 = const LatLng(30.214859, 31.365583);

  Map<int, OrderStatus> orderStatuses = {
    1: OrderStatus.pending,
    2: OrderStatus.waitingforDriver,
    3: OrderStatus.driverAccepted,
    4: OrderStatus.delivered,
    5: OrderStatus.cancelled,
  };

  RxBool isLastOrdersLoading = false.obs;
  RxList<OrderDatum> lastOrderDatumList = <OrderDatum>[].obs;

  getLastOrders() async {
    isLastOrdersLoading.value = true;
    Map<String, dynamic>? data = await provider.getLatestOrders();
    isLastOrdersLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          lastOrderDatumList.value = (data['data'] as OrdersModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting last orders');
        }
      }
    }
  }

  RxBool isOrderDetailsLoading = false.obs;
  Rx<OrderDetailsModel> orderDetailsData = OrderDetailsModel().obs;

  orderDetails(String orderNum) async {
    isOrderDetailsLoading.value = true;
    Map<String, dynamic>? data =
        await provider.getOrderDetails(orderNum: orderNum);
    isOrderDetailsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          log("Dattaaa ${data['data']}");
          orderDetailsData.value = data['data'] as OrderDetailsModel;
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured on getting order details');
    }
  }

  RxBool isPolyline = false.obs;
  RxString totalDistance = ''.obs;
  RxString totalTime = ''.obs;
  // Map<PolylineId, Polyline> polyliness = {};
  List<LatLng> polylineCoordinates = [];

  createDirectionsPolyline(
      {required LatLng currentLoc, required LatLng destinationLoc}) async {
    isPolyline.value = true;
    polylineCoordinates = [];
    polylines.value = <PolylineId, Polyline>{};
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyAE0PTLuDwCLMCAdakZ3l6lEM6C7BJz3bc",
        request: PolylineRequest(
          origin: PointLatLng(currentLoc.latitude, currentLoc.longitude),
          destination:
              PointLatLng(destinationLoc.latitude, destinationLoc.longitude),
          mode: TravelMode.driving,
        ),
      );
      isPolyline.value = false;
      log('Crees : ${result.status}');

      if (result.status == 'OK') {
        if (result.points.isNotEmpty) {
          totalDistance.value = result.totalDistanceValue.toString();
          totalTime.value = result.totalDurationValue.toString();
          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
          PolylineId id =
              PolylineId("${currentLoc.latitude}//${destinationLoc.longitude}");
          Polyline polyline = Polyline(
            polylineId: id,
            width: 5,
            color: Colors.deepPurpleAccent,
            visible: true,
            endCap: Cap.roundCap,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            points: polylineCoordinates,
          );
          polylines.value[id] = polyline;
        }
      }
    } catch (e) {
      isPolyline.value = false;
      Ui.errorGetBar(message: 'Unable to get the route'.tr);
    }
  }

  createTrackingPolyline(
      {required LatLng currentLoc,
      required LatLng destinationLoc,
      required LatLng driverLoc}) async {
    isPolyline.value = true;
    polylineCoordinates = [];
    polylines.value = <PolylineId, Polyline>{};
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyAE0PTLuDwCLMCAdakZ3l6lEM6C7BJz3bc",
      request: PolylineRequest(
        origin: PointLatLng(driverLoc.latitude, driverLoc.longitude),
        destination:
            PointLatLng(destinationLoc.latitude, destinationLoc.longitude),
        mode: TravelMode.driving,
        wayPoints: [
          PolylineWayPoint(
              location: '${currentLoc.latitude},${currentLoc.longitude}',
              stopOver: true)
        ],
      ),
    );

    isPolyline.value = false;

    if (result.points.isNotEmpty) {
      totalDistance.value = result.totalDistanceValue.toString();
      totalTime.value = result.totalDurationValue.toString();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      PolylineId id =
          PolylineId("${currentLoc.latitude}//${destinationLoc.longitude}");
      Polyline polyline = Polyline(
        polylineId: id,
        width: 5,
        color: Colors.deepPurpleAccent,
        visible: true,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        points: polylineCoordinates,
      );
      polylines.value[id] = polyline;
    }
  }

  RxBool isOrdersLoading = false.obs;
  RxList<OrderDatum> orderDatumList = <OrderDatum>[].obs;

  getOrders() async {
    isOrdersLoading.value = true;
    Map<String, dynamic>? data = await provider.getAllOrders();
    isOrdersLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          orderDatumList.value = (data['data'] as OrdersModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting orders');
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured on getting orders');
    }
  }

  RxBool offerLoading = false.obs;
  RxList<OffersDatum> offerDatumList = <OffersDatum>[].obs;

  cancelOrders(String orderNum) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.postCancelOrder(orderNum: orderNum);
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.back();
          Ui.successGetBar(
              message: (data['data'] as NoDataResponseModel).message!);
          getLastOrders();
          getOrders();
        } else {
          Ui.errorGetBar(message: 'error occured when canceling order');
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured when canceling order');
    }
  }

  regenerateCode(String orderNum) async {
    // Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.getRegenerateCode(orderNum: orderNum);
    Get.log("fff ${data}");
    // Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          String deliveredCode = data['data']['delivered_code'].toString();
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'Order Delivered'.tr.titleSmall(),
                    const SizedBox(height: 15),
                    deliveredCode.bodyMedium(center: true),
                    const SizedBox(height: 15),
                    GlobalButton(
                      onTap: () {
                        if (deliveredCode.isNotEmpty) {
                          Clipboard.setData(
                            ClipboardData(text: deliveredCode),
                          ).then((v) {
                            Get.back();
                            Get.bottomSheet(
                              BottomSheet(
                                onClosing: () {},
                                builder: (context) => const RatingDialog(),
                              ),
                            );
                          });
                        } else {
                          Get.back();
                        }
                      },
                      text: 'Copy Code'.tr,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured when regenerating code');
    }
  }

  RxInt chatId = 0.obs;

  Future getChatMessages(int driverId) async {
    socketServices.isChatsMessagesLoading.value = true;
    Map<String, dynamic>? data = await provider.getChatWithDriverId(driverId);
    if (data != null) {
      socketServices.isChatsMessagesLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          socketServices.messages.value = List.generate(
            (data['data'] as ChatMessagesModel).data!.messages!.length,
            (index) => Messages(
              status: MesssageStatus.sent,
              isAttachmentPath: false,
              message:
                  (data['data'] as ChatMessagesModel).data!.messages![index],
            ),
          );
          chatId.value = (data['data'] as ChatMessagesModel).data!.id!;
        } else if (data['code'] == 404) {
          Ui.errorGetBar(
              message: (data['data'] as NoDataResponseModel).message!);
        } else {
          Ui.errorGetBar(message: 'error occured on getting chat messages');
        }
      }
    } else {
      socketServices.isChatsMessagesLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting chat messages');
    }
  }

  RxDouble currentLat = 0.0.obs;
  RxDouble currentLong = 0.0.obs;
  RxDouble destLat = 0.0.obs;
  RxDouble destLong = 0.0.obs;
  RxString minCost = ''.obs;
  RxString maxCost = ''.obs;
  RxString urgent = ''.obs;
  Rx<DeliveryCostModel> deliveryCostModel = DeliveryCostModel().obs;

  getDeliveryCost({
    required String orderNum,
    required int importance,
    // required int countryId,
    required int vehicleId,
  }) async {
    Ui.loadingDialog();

    print('GGGGGGGGGGGGGGGG');
    print(countriesList
            .where((e) => e.code! == appServices.userCountryCode.value)
            .isEmpty
        ? 1
        : countriesList
            .where((e) => e.code! == appServices.userCountryCode.value)
            .first
            .id!);
    Map<String, dynamic>? data = await provider.getMinMaxCost(
      distance: double.parse(appServices
          .calculateDistance(
            currentLoc: LatLng(currentLat.value, currentLong.value),
            destination: LatLng(destLat.value, destLong.value),
          )
          .toStringAsFixed(2)),
      urgent: importance,
      countryId: countriesList
              .where((e) => e.code! == appServices.userCountryCode.value)
              .isEmpty
          ? 1
          : countriesList
              .where((e) => e.code! == appServices.userCountryCode.value)
              .first
              .id!,
      vehicleCategoryId: vehicleId,
      type: appServices.userType.value.toJson().toLowerCase(),
    );

    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          deliveryCostModel.value = data['data'] as DeliveryCostModel;
          minCost.value = (data['data'] as DeliveryCostModel).data!.minCost!;
          maxCost.value = (data['data'] as DeliveryCostModel).data!.maxCost!;
          urgent.value = (data['data'] as DeliveryCostModel).data!.urgent!;
          Map<String, dynamic>? offersData =
              await provider.getOrderOffers(orderNum: orderNum);
          Get.back();
          if (offersData != null) {
            if (offersData['code'] == 200) {
              socketServices.offersList.value =
                  (offersData['data'] as OffersModel)
                      .data!
                      .map(
                        (e) => Offers(
                          id: e.id,
                          driverId: e.driver!.id,
                          driverName: e.driver!.driverName,
                          price: e.price!,
                          driverAvatar: e.driver!.driverPhoto,
                          rate: e.driver!.rate,
                        ),
                      )
                      .toList();
            }
          }
          Get.toNamed(Routes.offers,
              arguments: [minCost.value, maxCost.value, urgent.value]);
        } else {
          Get.back();
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'error occured while getting delivery cost');
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

  @override
  void onReady() {
    super.onReady();
    // drawPolylines();
    getCountriesList();
    getOrders();
  }
}
