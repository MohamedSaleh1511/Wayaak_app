import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/all_chats_model/all_chats_model.dart';
import 'package:wayaak/app/data/models/all_chats_model/datum.dart';
import 'package:wayaak/app/data/models/chat_messages_model/chat_messages_model.dart';
import 'package:wayaak/app/data/models/chat_messages_model/message.dart';
import 'package:wayaak/app/data/models/chat_messages_model/messages.dart';
import 'package:wayaak/app/data/models/chat_messages_model/sender.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/data/services/socket_service.dart';
import 'package:wayaak/app/modules/chat/providers/chat_provider.dart';

class ChatController extends GetxController {
  final SocketServices socketServices = Get.find<SocketServices>();
  final AppServices appServices = Get.find<AppServices>();
  final ChatProvider provider = Get.find<ChatProvider>();

  final TextEditingController chatFieldController = TextEditingController();

  RxBool isChatsLoading = false.obs;
  RxList<ChatsDatum> chatsDatumList = <ChatsDatum>[].obs;
  RxList<ChatsDatum> chatsList = <ChatsDatum>[].obs;
  getAllChats() async {
    isChatsLoading.value = true;
    Map<String, dynamic>? data = await provider.getAllChats();
    if (data != null) {
      isChatsLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          chatsDatumList.value = (data['data'] as AllChatsModel).data!;
          chatsList.value = (data['data'] as AllChatsModel).data!;
        } else if (data['code'] == 403) {
          Ui.errorGetBar(
              message: (data['data'] as GlobalResponseModel).message!);
        }
      }
    } else {
      isChatsLoading.value = false;
    }
  }

  getChatMessages(int chatId) async {
    socketServices.isChatsMessagesLoading.value = true;
    Map<String, dynamic>? data = await provider.getChatMessages(chatId);
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
        } else if (data['code'] == 403) {
          // Ui.errorGetBar(message: (data['data'] as GlobalResponseModel).message!);
        }
      }
    } else {
      socketServices.isChatsMessagesLoading.value = false;
    }
  }

  RxBool isNewMessageLoading = false.obs;
  Rx<File> chatAttachment = File('').obs;
  addNewMessage({required int receiverId, required String message}) async {
    socketServices.messages.add(
      Messages(
        status: MesssageStatus.loading,
        isAttachmentPath: true,
        message: ChatMessage(
          attachment: (chatAttachment.value.path.isEmpty)
              ? null
              : chatAttachment.value.path,
          message: message,
          id: 0,
          sender: Sender(
            id: appServices.userId.value,
            name: appServices.userName.value,
            phone: appServices.userPhone.value,
            avatar: appServices.userImage.value,
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );
    isNewMessageLoading.value = true;
    chatFieldController.text = '';

    File attach = chatAttachment.value;

    chatAttachment.value = File('');

    Map<String, dynamic>? data =
        await provider.postNewMessage(receiverId, message, attach);
    if (data != null) {
      isNewMessageLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.log("Message Added Successfully");
          int indexx = socketServices.messages
              .indexWhere((v) => v.message!.message! == message);

          if (indexx != -1) {
            socketServices.messages[indexx].status = MesssageStatus.sent;
            socketServices.messages.refresh();
            socketServices.messages.refresh();
          }
        } else {
          int indexx = socketServices.messages
              .indexWhere((v) => v.message!.message! == message);
          if (indexx != -1) {
            socketServices.messages[indexx].status = MesssageStatus.failed;
            socketServices.messages.refresh();
            socketServices.messages.refresh();
          }
        }
      }
    } else {
      isNewMessageLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    getAllChats();
  }
}
