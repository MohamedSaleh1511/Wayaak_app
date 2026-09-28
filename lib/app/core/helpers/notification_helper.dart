import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/data/services/socket_service.dart';
import 'package:wayaak/app/modules/chat/controllers/chat_controller.dart';
import 'package:wayaak/app/modules/chat/providers/chat_provider.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';
import 'package:wayaak/firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationsHelper {
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    enableLights: true,
    ledColor: Constants.primary,
    showBadge: true,
  );

  static init() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (payload) async {
        log('On Message Clicked ====> ${jsonDecode(payload.payload!)}');
        Map<String, dynamic> data = jsonDecode(payload.payload!);

        if (data.isNotEmpty) {
          switch (data['type']) {
            case 'order-offer':
              Get.put(OrdersController()).currentLat.value =
                  double.parse(data['current_loc_lat'].toString());
              Get.put(OrdersController()).currentLong.value =
                  double.parse(data['current_loc_long'].toString());
              Get.put(OrdersController()).destLat.value =
                  double.parse(data['dest_loc_lat'].toString());
              Get.put(OrdersController()).destLong.value =
                  double.parse(data['dest_loc_long'].toString());
              Get.find<AppServices>().orderNum.value =
                  data['order_num'].toString();
              Get.find<SocketServices>().checkBroadcastAuth(
                  "private-order-offers.${data['order_num']}");

              Get.put(OrdersController()).getDeliveryCost(
                orderNum: data['order_num'].toString(),
                importance: data['urgent'] == 'No' ? 0 : 1,
                // countryId: data['country'].toString() == 'EG' ? 1 : 3,
                vehicleId: int.parse(data['vehicle_category_id']),
              );
              break;
            case 'new-order':
              if (jsonDecode((data['order']))['order_num'] != null) {
                Get.put(HomeController())
                    .orderController
                    .orderDetails(jsonDecode((data['order']))['order_num']);

                Get.toNamed(Routes.orderDetails);
              }
              break;

            case 'chat':
              Get.find<SocketServices>().chatChannelName.value =
                  "private-chat.${data['chat_id']}";
              Get.find<SocketServices>()
                  .checkBroadcastAuth("private-chat.${data['chat_id']}");
              Get.put(ChatController())
                  .getChatMessages(int.parse(data['chat_id'].toString()));
              Get.toNamed(Routes.chatMessages, arguments: [
                data['sender_avatar'],
                data['sender_name'],
                data['sender_id'],
                data['chat_id'],
              ]);
              break;
            case 'order-delivered':
              Get.find<HomeController>().orderStatus(
                orderNum: int.parse(data['order_num'] ?? '0'),
                driverId: int.parse(data['driver_id']),
                payment: data['payment'],
                totalPrice: data['total_price'],
                randomNumber: data['randomNumber'],
                messageAr: data['message'],
                messageEn: data['message'],
                paymentUrl: data['payment_url'],
              );
              break;
            case 'wallet-charged':
              Get.back();
              Get.put(HomeController()).pageController.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeInOut,
                  );
              Get.put(HomeController()).currentIndex.value = 3;
              break;
            default:
              Get.toNamed(Routes.notification);
          }
        }
        return;
      },
    );
  }

  static show(RemoteMessage message) async {
    log('Notification Payload ==> ${message.toMap()}');
    log('Current Route ==> ${Get.currentRoute}');
    if ((Get.currentRoute == Routes.chatMessages &&
        message.data['type'] == 'chat')) {
    } else {
      if (message.data['type'] == 'chat') {
        Get.put(ChatController()).getAllChats();
      }
      await flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            priority: Priority.max,
            enableLights: true,
            ledColor: Constants.primary,
            audioAttributesUsage: AudioAttributesUsage.notification,
            ledOnMs: 2,
            ledOffMs: 2,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );

      if (message.data['type'] == 'order-delivered') {
        Get.put(ChatController()).socketServices.unsubscribeChannel(
            'private-user-location.${(message.data['driver_id'])}');
        Get.find<HomeController>().getCurrentShipment();
        Get.find<HomeController>().orderController.getLastOrders();
      }
    }
  }

  static handleNotificationCallback(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      switch (message.data['type']) {
        case 'new-order':
          if (jsonDecode((message.data['order']))['order_num'] != null) {
            Get.put(HomeController())
                .orderController
                .orderDetails(jsonDecode((message.data['order']))['order_num']);
            Get.toNamed(Routes.orderDetails);
          }
          break;
        case 'chat':
          Get.find<SocketServices>().chatChannelName.value =
              "private-chat.${message.data['chat_id']}";
          Get.find<SocketServices>()
              .checkBroadcastAuth("private-chat.${message.data['chat_id']}");
          Get.lazyPut<ChatProvider>(() => ChatProvider());
          Get.put(ChatController())
              .getChatMessages(int.parse(message.data['chat_id']));
          Get.toNamed(Routes.chatMessages, arguments: [
            message.data['sender_avatar'],
            message.data['sender_name'],
            int.parse(message.data['sender_id']),
            message.data['chat_id'],
          ]);
          break;
        case 'order-delivered':
          Get.find<HomeController>().orderStatus(
              orderNum: int.parse(message.data['order_num'] ?? '0'),
              driverId: int.parse(message.data['driver_id']),
              payment: message.data['payment'],
              totalPrice: message.data['total_price'],
              randomNumber: message.data['randomNumber'],
              messageAr: message.data['message'],
              messageEn: message.data['message'],
              paymentUrl: message.data['payment_url']);
          break;
        case 'wallet-charged':
          Get.back();
          Get.put(HomeController()).pageController.animateToPage(
                3,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
              );
          Get.put(HomeController()).currentIndex.value = 3;
          break;
        case 'order-offer':
          Get.put(OrdersController()).currentLat.value =
              double.parse(message.data['current_loc_lat'].toString());
          Get.put(OrdersController()).currentLong.value =
              double.parse(message.data['current_loc_long'].toString());
          Get.put(OrdersController()).destLat.value =
              double.parse(message.data['dest_loc_lat'].toString());
          Get.put(OrdersController()).destLong.value =
              double.parse(message.data['dest_loc_long'].toString());
          Get.find<AppServices>().orderNum.value =
              message.data['order_num'].toString();
          Get.find<SocketServices>().checkBroadcastAuth(
              "private-order-offers.${message.data['order_num']}");

          Get.put(OrdersController()).getDeliveryCost(
            orderNum: message.data['order_num'].toString(),
            importance: message.data['urgent'] == 'No' ? 0 : 1,
            // countryId: message.data['country'].toString() == 'EG' ? 1 : 3,
            vehicleId: int.parse(message.data['vehicle_category_id']),
          );
          break;
        default:
          Get.toNamed(Routes.notification);
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> notificationsBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Notification Payload ==> ${message.toMap()}');
}
