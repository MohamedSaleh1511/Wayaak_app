import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:lottie/lottie.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/chat_messages_model/messages.dart';
import 'package:wayaak/app/modules/chat/controllers/chat_controller.dart';
import 'package:wayaak/app/modules/chat/widgets/chat_appbar.dart';
import 'package:wayaak/app/modules/chat/widgets/message_status_part.dart';

class ChatMessagesView extends GetView<ChatController> {
  const ChatMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        controller.socketServices
            .unsubscribeChannel('private-chat.${Get.arguments[3]}');
      },
      child: Scaffold(
        appBar: ChatAppbar(
          name: Get.arguments[1],
          avatar: Get.arguments[0] ?? '',
        ),
        extendBody: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          child: Obx(() {
            if (controller.socketServices.isChatsMessagesLoading.value) {
              return Center(
                child:
                    Lottie.asset('assets/lotties/dots-loader.json', width: 80),
              );
            } else {
              if (controller.socketServices.messages.isEmpty) {
                return Center(child: "Add your first message".tr.bodyMedium());
              } else {
                return ListView.builder(
                  itemCount: controller.socketServices.messages.length,
                  shrinkWrap: true,
                  reverse: false,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: kBottomNavigationBarHeight + 36),
                  itemBuilder: (context, index) {
                    Messages message =
                        controller.socketServices.messages[index];
                    int id = controller
                        .socketServices.messages[index].message!.sender!.id!;
                    return UnconstrainedBox(
                      alignment: (id != controller.appServices.userId.value
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(top: 5),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (id != controller.appServices.userId.value) ...{
                              CircleAvatar(
                                radius: 16.6,
                                backgroundColor:
                                    Get.theme.colorScheme.secondary,
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ClipOval(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child:
                                        '${Constants.baseUrl}storage/${message.message!.sender!.avatar ?? ""}'
                                            .image(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                            },
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                LimitedBox(
                                  maxWidth: Get.width * 0.65,
                                  child: Align(
                                    alignment: (id !=
                                            controller.appServices.userId.value
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16).copyWith(
                                          topLeft: (id !=
                                                  controller
                                                      .appServices.userId.value
                                              ? const Radius.circular(0)
                                              : const Radius.circular(16)),
                                          topRight: (id !=
                                                  controller
                                                      .appServices.userId.value
                                              ? const Radius.circular(16)
                                              : const Radius.circular(0)),
                                        ),
                                        color: (id !=
                                                controller
                                                    .appServices.userId.value
                                            ? Constants.softGrey
                                            : Get.theme.primaryColor),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: id !=
                                                controller
                                                    .appServices.userId.value
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              message.message!.message!.caption(
                                                color: (id !=
                                                        controller.appServices
                                                            .userId.value
                                                    ? Colors.black
                                                    : Colors.white),
                                                weight: FontWeight.w500,
                                              ),
                                              if (message.message!.attachment !=
                                                  null) ...{
                                                const SizedBox(height: 3),
                                                LimitedBox(
                                                  maxHeight: 120,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: (message
                                                            .isAttachmentPath!)
                                                        ? InkWell(
                                                            onTap: () {
                                                              Get.generalDialog(
                                                                transitionBuilder:
                                                                    (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                  Tween<Offset>
                                                                      tween;
                                                                  if (animation
                                                                          .status ==
                                                                      AnimationStatus
                                                                          .reverse) {
                                                                    tween = Tween(
                                                                        begin: const Offset(
                                                                            0,
                                                                            1),
                                                                        end: Offset
                                                                            .zero);
                                                                  } else {
                                                                    tween = Tween(
                                                                        begin: const Offset(
                                                                            0,
                                                                            1),
                                                                        end: Offset
                                                                            .zero);
                                                                  }

                                                                  return SlideTransition(
                                                                    position: tween.animate(CurvedAnimation(
                                                                        parent:
                                                                            animation,
                                                                        curve: Curves
                                                                            .fastEaseInToSlowEaseOut)),
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                                transitionDuration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            600),
                                                                pageBuilder: (context,
                                                                        animation,
                                                                        secondaryAnimation) =>
                                                                    InteractiveViewer(
                                                                  child: Image
                                                                      .file(
                                                                    File(message
                                                                        .message!
                                                                        .attachment!),
                                                                    errorBuilder: (context,
                                                                            s,
                                                                            v) =>
                                                                        Image.asset(
                                                                            'assets/images/logo.png'),
                                                                  ),
                                                                ),
                                                                barrierColor:
                                                                    Colors
                                                                        .black,
                                                                barrierDismissible:
                                                                    true,
                                                                barrierLabel:
                                                                    'image preview',
                                                              );
                                                            },
                                                            child: Image.file(
                                                              File(message
                                                                  .message!
                                                                  .attachment!),
                                                              errorBuilder: (context,
                                                                      s, v) =>
                                                                  Image.asset(
                                                                      'assets/images/logo.png'),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              Get.generalDialog(
                                                                transitionBuilder:
                                                                    (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                  Tween<Offset>
                                                                      tween;
                                                                  if (animation
                                                                          .status ==
                                                                      AnimationStatus
                                                                          .reverse) {
                                                                    tween = Tween(
                                                                        begin: const Offset(
                                                                            0,
                                                                            1),
                                                                        end: Offset
                                                                            .zero);
                                                                  } else {
                                                                    tween = Tween(
                                                                        begin: const Offset(
                                                                            0,
                                                                            1),
                                                                        end: Offset
                                                                            .zero);
                                                                  }

                                                                  return SlideTransition(
                                                                    position: tween.animate(CurvedAnimation(
                                                                        parent:
                                                                            animation,
                                                                        curve: Curves
                                                                            .fastEaseInToSlowEaseOut)),
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                                transitionDuration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            600),
                                                                pageBuilder: (context,
                                                                        animation,
                                                                        secondaryAnimation) =>
                                                                    InteractiveViewer(
                                                                  child: Image
                                                                      .network(
                                                                    "${Constants.baseUrl}storage/${message.message!.attachment}",
                                                                  ),
                                                                ),
                                                                barrierColor:
                                                                    Colors
                                                                        .black,
                                                                barrierDismissible:
                                                                    true,
                                                                barrierLabel:
                                                                    'image preview',
                                                              );
                                                            },
                                                            child: "${Constants.baseUrl}storage/${message.message!.attachment}"
                                                                .image(
                                                                    isProfile:
                                                                        false),
                                                          ),
                                                  ),
                                                ),
                                              },
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          UnconstrainedBox(
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              child: Text(
                                                convertUtcToLocal(message
                                                    .message!.createdAt!),
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: (id !=
                                                          controller.appServices
                                                              .userId.value
                                                      ? Colors.black87
                                                      : Colors.white70),
                                                ),
                                                textDirection:
                                                    TextDirection.ltr,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                MessageStatusPart(
                                  status: controller
                                      .socketServices.messages[index].status!,
                                ),
                              ],
                            ),
                            if (id == controller.appServices.userId.value) ...{
                              const SizedBox(width: 5),
                              CircleAvatar(
                                radius: 16.6,
                                backgroundColor: Get.theme.primaryColor,
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ClipOval(
                                    child:
                                        '${Constants.baseUrl}storage/${message.message!.sender!.avatar ?? ""}'
                                            .image(),
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          }),
        ),
        resizeToAvoidBottomInset: true,
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15)
              .copyWith(bottom: 8, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () {
                        if (controller.chatAttachment.value.path.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      controller.chatAttachment.value,
                                      fit: BoxFit.cover,
                                      height: 120,
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -10,
                                    child: LimitedBox(
                                      maxHeight: 30,
                                      maxWidth: 30,
                                      child: IconButton(
                                        onPressed: () {
                                          controller.chatAttachment.value =
                                              File('');
                                        },
                                        style: IconButton.styleFrom(
                                          iconSize: 20,
                                          padding: const EdgeInsets.all(0),
                                          backgroundColor:
                                              Get.theme.colorScheme.secondary,
                                        ),
                                        icon: const Icon(
                                          Icons.remove_circle_outline_outlined,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                            ],
                          );
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Constants.softGrey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18)),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.03),
                            blurRadius: 13,
                            offset: const Offset(0, 13),
                          ),
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.02),
                            blurRadius: 17,
                            offset: const Offset(0, 28),
                          ),
                        ],
                      ),
                      child: GlobalTextField(
                        controller: controller.chatFieldController,
                        contentPadding: 10,
                        noBorder: true,
                        hintText: 'Type here...'.tr,
                        suffixIcon: 'Plus',
                        onSuffixTap: () {
                          ImagePicker picker = ImagePicker();
                          controller.appServices.pickImage(
                            () async {
                              final imageSelected = await picker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 50,
                              );
                              if (imageSelected != null) {
                                controller.chatAttachment.value =
                                    File(imageSelected.path);
                              }
                              Get.back();
                            },
                            () async {
                              final imageSelected = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 50,
                              );
                              if (imageSelected != null) {
                                controller.chatAttachment.value =
                                    File(imageSelected.path);
                              }
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {
                  if (controller.chatFieldController.text.trim().isNotEmpty) {
                    controller.addNewMessage(
                      receiverId: int.parse(Get.arguments[2].toString()),
                      message: controller.chatFieldController.text,
                    );
                  }
                },
                icon: Transform.flip(
                  flipX: Get.locale == const Locale('ar'),
                  child: 'send'.iconColored(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convertUtcToLocal(DateTime utcTime) {
    // Parse the UTC time string
    DateTime utcDateTime = utcTime.toUtc();

    // Convert to local time
    DateTime localDateTime = utcDateTime.toLocal();

    // Format the local time as needed
    DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(localDateTime);
  }
}
