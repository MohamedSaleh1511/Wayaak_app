import 'dart:io';
import 'package:get/get.dart';
import 'package:wayaak/app/data/models/all_chats_model/all_chats_model.dart';
import 'package:wayaak/app/data/models/chat_messages_model/chat_messages_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/new_message_model/new_message_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class ChatProvider extends ApiProvider {
  // NOTE :- Get All Chats
  Future<Map<String, dynamic>?> getAllChats() async {
    Response res = await get('api/my_chats', headers: {
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
            : AllChatsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Update Profile
  Future<Map<String, dynamic>?> postNewMessage(
    int? receiverId,
    String? message,
    File? attachment,
  ) async {
    Response res = await post(
        'api/send_message',
        FormData({
          'receiver_id': receiverId,
          'receiver_type': "driver",
          'message': message,
          'attachment': attachment!.path.isEmpty
              ? null
              : MultipartFile(attachment,
                  filename: attachment.path.split('/').last),
        }),
        headers: {
          'Authorization':
              'Bearer ${Get.find<AppServices>().accessToken.value}',
        });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 400)
            ? GlobalResponseModel.fromJson(res.body)
            : NewMessageModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Update Profile
  Future<Map<String, dynamic>?> getChatMessages(
    int? chatId,
  ) async {
    Response res = await get('api/single_chat/$chatId', headers: {
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
        'data': (res.statusCode == 400)
            ? GlobalResponseModel.fromJson(res.body)
            : ChatMessagesModel.fromJson(res.body),
      };
    }
  }
}
