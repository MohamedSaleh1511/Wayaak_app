import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/chat_messages_model/message.dart';
import 'package:wayaak/app/data/models/chat_messages_model/messages.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/offers_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketServices extends ApiProvider {
  WebSocketChannel? channel;
  RxString socketId = ''.obs;
  RxString broadcastAuth = ''.obs;
  RxString chatChannelName = ''.obs;
  RxList<Messages> messages = <Messages>[].obs;
  RxBool isChatsMessagesLoading = false.obs;

  RxList<Offers> offersList = <Offers>[].obs;

  Rx<LatLng> driverRealTimeLoc = const LatLng(0.0, 0.0).obs;

  Rx<LatLng> driverLoc = const LatLng(0.0, 0.0).obs;
  late GoogleMapController mapController;

  requestSocketConnection(int userId) async {
    final wsUrl = Uri(
      scheme: 'wss',
      host: 'wyaak.com',
      path: '/ws/app/69152157138602498def',
      queryParameters: {
        'protocol': '7',
        'client': 'js',
        'version': '8.4.0-rc2',
        'flash': 'false',
      },
    );
    channel = WebSocketChannel.connect(wsUrl);

    await channel!.ready;
    channel!.stream.listen((message) {
      Get.log("message :: $message");
      Map<String, dynamic> outerJson = jsonDecode(message);
      String dataJsonString =
          outerJson.containsKey('data') ? outerJson['data'] : "";
      Map<String, dynamic> nestedJson = dataJsonString.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(dataJsonString);
      switch (outerJson['event']) {
        case 'pusher:connection_established':
          String id = nestedJson['socket_id'];
          socketId.value = id;
          Get.log('Socket ID: $socketId');
          break;
        case 'new-message':
          if (outerJson['channel'] == chatChannelName.value) {
            Get.log('new message: $nestedJson');
            ChatMessage bew = ChatMessage.fromJson(nestedJson['message']);
            if (bew.sender!.id! != userId) {
              messages.add(
                Messages(
                  status: MesssageStatus.sent,
                  isAttachmentPath: false,
                  message: bew,
                ),
              );
            }
          }
          break;
        case "new-offer":
          Get.log('new offer: $nestedJson');
          if (nestedJson['action'] == 'create') {
            Offers offer = Offers.fromJson(nestedJson);
            int existingOffer =
                offersList.indexWhere((v) => v.driverId == offer.driverId);
            if (existingOffer == -1) {
              offersList.add(offer);
            }
            // offersList;
          }
          // else if (nestedJson['action'] == 'cancel') {
          //   offersList
          //       .removeWhere((offer) => offer.id == nestedJson['offer_id']);
          // }
          break;
        case "pusher:ping":
          Get.log('message :: Pusher Ping');
          channel!.sink.add(jsonEncode({"event": "pusher:pong"}));
          break;
        case "App\\Events\\CurrentDriverLocation":
          Get.log('current location: $nestedJson');
          driverRealTimeLoc.value = LatLng(
              double.parse(nestedJson['latitude'].toString()),
              double.parse(nestedJson['longitude'].toString()));

          driverRealTimeLoc.refresh();
          mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                double.parse(nestedJson['latitude'].toString()),
                double.parse(nestedJson['longitude'].toString()),
              ),
            ),
          );
          break;
        default:
      }
    }, onDone: () {
      requestSocketConnection(userId);
    }, onError: (error) {
      requestSocketConnection(userId);
    });
  }

  // NOTE :- CHECK BROADCAST AUTH
  Future<Map<String, dynamic>?> getCheckBroadcastAuth(
      {required String socketId, required String channelName}) async {
    Response res = await post('api/broadcasting/auth', {
      "socket_id": socketId,
      "channel_name": channelName,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${Get.put<AppServices>(AppServices()).accessToken.value}',
    });
    if (res.status.isServerError || res.status.connectionError) {
      return null;
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': res.body,
      };
    }
  }

  RxBool broadcastAuthLoading = false.obs;
  checkBroadcastAuth(String channelName) async {
    broadcastAuthLoading.value = true;
    Map<String, dynamic>? data = await getCheckBroadcastAuth(
        socketId: socketId.value, channelName: channelName);
    broadcastAuthLoading.value = false;
    if (data != null) {
      if (data['code'] == 200) {
        Get.log(data['data']['auth']);
        channel!.sink.add(jsonEncode({
          "event": "pusher:subscribe",
          "data": {
            "channel": channelName,
            "auth": data['data']['auth'],
          }
        }));
      } else if (data['code'] == 403) {
        Ui.errorGetBar(message: (data['data'] as GlobalResponseModel).message!);
      } else {
        Ui.errorGetBar(message: 'error occured for broadcast');
      }
    } else {
      Get.log('Internal Server Error'.tr);
    }
  }

  unsubscribeChannel(String channelName) async {
    channel!.sink.add(jsonEncode({
      "event": "pusher:unsubscribe",
      "data": {"channel": channelName}
    }));
  }
}
