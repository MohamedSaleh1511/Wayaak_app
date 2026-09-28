import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/helpers/helpers.dart';
import 'package:wayaak/app/core/helpers/notification_helper.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/banners_model/banners_model.dart';
import 'package:wayaak/app/data/models/banners_model/datum.dart';
import 'package:wayaak/app/data/models/current_shipments_model/current_shipments_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/order_details_model/data.dart';
import 'package:wayaak/app/data/models/orders_model/datum.dart';
import 'package:wayaak/app/data/models/orders_model/orders_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/data/services/socket_service.dart';
import 'package:wayaak/app/modules/chat/views/chat_view.dart';
import 'package:wayaak/app/modules/home/providers/home_provider.dart';
import 'package:wayaak/app/modules/home/views/home_tab.dart';
import 'package:wayaak/app/modules/notification/widgets/rating_dialog.dart';
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';
import 'package:wayaak/app/modules/orders/views/orders_view.dart';
import 'package:wayaak/app/modules/profile/views/profile_view.dart';
import 'package:wayaak/app/modules/static_pages/controllers/static_pages_controller.dart';
import 'package:wayaak/app/modules/support/controllers/support_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  final HomeProviders provider = Get.find<HomeProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final SocketServices socketServices = Get.find<SocketServices>();
  final StaticPagesController staticController =
      Get.find<StaticPagesController>();
  final OrdersController orderController = Get.find<OrdersController>();
  final SupportController supportController = Get.find<SupportController>();
  RxInt currentIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchTextController = TextEditingController();
  final List<Widget> pages = [
    const HomeTab(),
    const OrdersView(),
    const ChatView(),
    const ProfileView(),
  ];

  RxBool isSearchOrdersLoading = false.obs;
  RxList<OrderDatum> searchOrderData = <OrderDatum>[].obs;
  searchOrders() async {
    isSearchOrdersLoading.value = true;
    Map<String, dynamic>? data = await provider.searchOrders(
      orderNum: searchTextController.text.isNum
          ? searchTextController.text.trim()
          : '',
      orderTitle: searchTextController.text.isNum
          ? ''
          : searchTextController.text.trim(),
    );
    isSearchOrdersLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          searchOrderData.value = (data['data'] as OrdersModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured while searching about order');
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured while searching about order');
    }
  }

  RxBool isBannersLoading = false.obs;
  RxList<BannerData> bannersList = <BannerData>[].obs;
  getBanners() async {
    isBannersLoading.value = true;
    Map<String, dynamic>? data = await provider.banners();
    isBannersLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          bannersList.value = (data['data'] as BannersModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on Banners');
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured on Banners');
    }
  }

  RxBool isCurrentShipmentLoading = false.obs;
  RxList<OrderDetailsDataa> currentShipmentData = <OrderDetailsDataa>[].obs;
  getCurrentShipment() async {
    isCurrentShipmentLoading.value = true;
    Map<String, dynamic>? data = await provider.getCurrentShipment();
    isCurrentShipmentLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          currentShipmentData.value =
              (data['data'] as CurrentShipmentsModel).data!;
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured on Current shipment');
    }
  }

  final TextEditingController commentController = TextEditingController();
  RxDouble rate = 3.5.obs;
  addDriverReview(int driverId) async {
    Ui.loadingDialog();
    Get.log(rate.value.toString());
    Map<String, dynamic>? data = await provider.rateDriver(
      comment: commentController.text,
      rate: rate.value,
      driverId: driverId,
    );
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.back();
          rate.value = 0.0;
          commentController.text = '';
          Ui.successGetBar(
              message:
                  "Thanks for your rate, please send the code to the driver"
                      .tr);
        } else {
          Get.back();
          rate.value = 0.0;
          commentController.text = '';
          Ui.errorGetBar(
              message: (data['data'] as GlobalResponseModel).message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  orderStatus({
    required int orderNum,
    required int driverId,
    required String payment,
    String? messageEn,
    String? messageAr,
    required String totalPrice,
    required String? paymentUrl,
    required String? randomNumber,
    String? readAt,
  }) async {
    Ui.loadingDialog();
    Get.log(rate.value.toString());
    Map<String, dynamic>? data = await provider.orderStatus(
      orderNum: orderNum,
    );
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          if (OrderStatus.fromJson(data['data']['data']['status']) ==
              OrderStatus.delivered) {
            Ui.successGetBar(
                message: "This order has been delivered successfully".tr);
          } else {
            appServices.driverId.value = driverId;
            if (payment == 'Credit' && (totalPrice != '0') && paymentUrl != null) {
              if (readAt == null) {
                appServices.orderNum.value = orderNum.toString();
                handlingOnlinePayment(
                  expiryDate: "2026-08-06T17:51:36.908615+03:00",
                  totalPrice:
                      totalPrice.isEmpty ? 0.0 : double.parse(totalPrice),
                  messageAr: messageAr ?? '',
                  messageEn: messageEn ?? '',
                  randomCode: randomNumber!,
                  paymentUrl: paymentUrl,
                );
              } else {
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
                          '${Get.locale == const Locale('ar') ? messageAr : messageEn}'
                              .bodyMedium(center: true),
                          const SizedBox(height: 15),
                          GlobalButton(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: '$randomNumber',
                                ),
                              ).then((v) {
                                Get.back();
                                Get.bottomSheet(
                                  BottomSheet(
                                    onClosing: () {},
                                    builder: (context) => const RatingDialog(),
                                  ),
                                );
                              });
                            },
                            text: 'Copy Code'.tr,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
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
                        '${Get.locale == const Locale('ar') ? messageAr : messageEn}'
                            .bodyMedium(center: true),
                        const SizedBox(height: 15),
                        GlobalButton(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: '$randomNumber',
                              ),
                            ).then((v) {
                              Get.back();
                              Get.bottomSheet(
                                BottomSheet(
                                  onClosing: () {},
                                  builder: (context) => const RatingDialog(),
                                ),
                              );
                            });
                          },
                          text: 'Copy Code'.tr,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        } else {
          Get.back();
          rate.value = 0.0;
          commentController.text = '';
          Ui.errorGetBar(
              message: (data['data'] as GlobalResponseModel).message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  // ANCHOR ----->  Log out Function
  logout() async {
    Ui.loadingDialog();
    Get.log("Access Token: ${appServices.accessToken.value}");
    await provider.postLogout();
    Get.back();
    Get.offAllNamed(Routes.login);
    appServices.removeUserData();
  }

// ANCHOR ----->  Log out Function
  deleteAccount() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.deleteAccount();
    if (data!['data'] == null) {
      Get.back();
      Ui.errorGetBar(
          message: 'Error has been occured, Please try again later'.tr);
    } else {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.offAllNamed(Routes.login);
          appServices.removeUserData();
        } else {
          Ui.errorGetBar(
              message: 'Error has been occured, Please try again later'.tr);
        }
      }
    }
  }

  Rx<Position> currentLocation = Position(
    longitude: 13.0,
    latitude: 13.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  ).obs;

  Future<Position> getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );
    } else {
      await Permission.location.request();
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );
    }
  }

  setCurrentLocation() async {
    currentLocation.value = await getCurrentLocation();
    debugPrint('Current location : ${currentLocation.value}');
    await getPlaceMark();
  }

  Future<void> getPlaceMark() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.value.latitude, currentLocation.value.longitude);

    appServices.saveCountryCode(placemarks[0].isoCountryCode ?? 'EG');
    appServices.saveCurrencyCode(
        getCurrencyCode(placemarks[0].isoCountryCode ?? 'EG')!);
  }

  RxString trancMessageAr = ''.obs;
  RxString trancMessageEn = ''.obs;
  RxString trancRandomCode = ''.obs;
  handlingOnlinePayment({
    required String expiryDate,
    required double totalPrice,
    required String messageAr,
    required String messageEn,
    required String randomCode,
    required String? paymentUrl,
  }) async {
    Ui.loadingDialog();
    // const paymentUrl = 'https://api.sofcopay.com/Express?lang=en';
    //
    // var bytes1 = utf8.encode(
    //     "SOfCOPay_8mWnXndPARLg${appServices.orderId.value}${appServices.userId.value}https://www.google.com6b5fdea340e31b3b0339d4d4ae51${totalPrice.toStringAsFixed(2)}${totalPrice.toStringAsFixed(2)}256a0b10-d7e3-4592-9a27-ae17f76b54ad_SOfCOPay");
    //
    // var digest1 = sha256.convert(bytes1);
    // Get.log("SHA256 :: $digest1");
    // Map<String, dynamic> data = {
    //   "merchantId": 3,
    //   "merchantCode": "8mWnXndPARLg",
    //   "referenceNumber": appServices.orderId.value,
    //   "customer": {
    //     "id": "${appServices.userId.value}",
    //     "name": appServices.userName.value,
    //     "email": appServices.userEmail.value,
    //     "phone": appServices.userPhone.value
    //   },
    //   "expiryDate": expiryDate,
    //   "items": [
    //     {
    //       "type": "ChargeRequest",
    //       "id": "6b5fdea340e31b3b0339d4d4ae5",
    //       "description": "Product Description",
    //       "price": totalPrice,
    //       "quantity": 1.00,
    //       "imageUrl": "https://developer.fawrystaging.com/photos/45566.jpg",
    //       "total": totalPrice
    //     }
    //   ],
    //   "total": totalPrice,
    //   "shippingAddress": null,
    //   "paymentMethod": null,
    //   "status": 0,
    //   "returnUrl": "https://www.google.com",
    //   "signature": "$digest1",
    //   "paymentURL": "",
    //   "statusCode": "",
    //   "statusDescription": "",
    //   "pgwRefNum": "",
    //   "id": null,
    //   "createdDate": "2024-07-20T10:51:36.908424Z",
    //   "lastUpdatedDate": "2024-07-20T10:51:36.908466Z",
    //   "createdBy": "system",
    //   "lastCreatedBy": "system",
    //   "isActive": true
    // };

    trancMessageAr.value = messageAr;
    trancMessageEn.value = messageEn;
    trancRandomCode.value = randomCode;

    try {
      // var response = await Dio().postUri(Uri.parse(paymentUrl), data: data);
      // Get.log("Response :: ${response.data}");
      Get.back();

      // if (response.statusCode == 200) {
      //   appServices.referenceNumber.value =
      //       (jsonDecode(response.data))['referenceNumber'];
      //   appServices.webViewUrl.value = (jsonDecode(response.data))['url'];
      if(paymentUrl != null) {
        appServices.webViewUrl.value = paymentUrl;
        Get.offNamed(Routes.checkout, arguments: 'Payment');
      }
      // }
    } on DioException catch (e) {
      Get.log("Dio Exception :: ${e.message}");
      Get.log("Dio Exception :: ${e.error}");
      Get.log("Dio Exception :: ${e.response!.statusCode!}");
    }
  }

  updateTransaction(String messageAr, String messageEn) async {
    print('HELPHELP');
    print(messageAr);
    print(messageEn);
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.updateTransaction(
      orderNum: appServices.orderNum.value,
      referenceNum: appServices.referenceNumber.value,
    );
    print('#############');
    print(data);
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
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
                    (Get.locale == const Locale('ar') ? messageAr : messageEn)
                        .bodyMedium(center: true),
                    const SizedBox(height: 15),
                    GlobalButton(
                      onTap: () {
                        RegExp regExp = RegExp(r'\d+');
                        Iterable<Match> matches = regExp.allMatches(messageEn);

                        List<int> codes = matches
                            .map((match) => int.parse(match.group(0)!))
                            .toList();
                        Clipboard.setData(
                          ClipboardData(
                              text:
                                  '${codes.where((e) => e.abs().toString().length == 6).first}'),
                        ).then((v) {
                          Get.back();
                          Get.bottomSheet(
                            BottomSheet(
                              onClosing: () {},
                              builder: (context) => const RatingDialog(),
                            ),
                          );
                        });
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
      Ui.errorGetBar(message: 'error occured while updating transaction');
    }
  }

  getTheNotificationData() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    return initialMessage;
  }

  @override
  void onReady() async {
    super.onReady();

    if (appServices.accessToken.value.isNotEmpty) {
      RemoteMessage? message = await getTheNotificationData();
      if (message != null) {
        log('Initial Message Received: ${message.data}');
        NotificationsHelper.handleNotificationCallback(message);
      }
      orderController.getLastOrders();
      getBanners();
      getCurrentShipment();
      await setCurrentLocation();
      socketServices.requestSocketConnection(appServices.userId.value);
    }
  }
}
