import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/support/controllers/support_controller.dart';

class TicketChatView extends GetView<SupportController> {
  const TicketChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: '${'Ticket'.tr} #${Get.arguments}'),
      extendBody: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Obx(() {
          if (controller.isRepliesLoading.value) {
            return Center(
              child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
            );
          } else {
            if (controller.ticketReplies.isEmpty) {
              return Center(child: "Add your first message".tr.bodyMedium());
            } else {
              return ListView.builder(
                itemCount: controller.ticketReplies.length,
                shrinkWrap: true,
                reverse: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 10, bottom: kBottomNavigationBarHeight + 36),
                itemBuilder: (context, index) {
                  return UnconstrainedBox(
                    alignment: (controller.ticketReplies[index].type != 'user'
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: Get.width * 0.3,
                        maxWidth: Get.width * 0.65,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        child: Align(
                          alignment:
                              (controller.ticketReplies[index].type != 'user'
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15).copyWith(
                                topLeft:
                                    (controller.ticketReplies[index].type !=
                                            'user'
                                        ? const Radius.circular(0)
                                        : const Radius.circular(15)),
                                topRight:
                                    (controller.ticketReplies[index].type !=
                                            'user'
                                        ? const Radius.circular(15)
                                        : const Radius.circular(0)),
                              ),
                              color: (controller.ticketReplies[index].type !=
                                      'user'
                                  ? Constants.softGrey
                                  : Get.theme.primaryColor),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Column(
                              crossAxisAlignment:
                                  controller.ticketReplies[index].type != 'user'
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.ticketReplies[index].message!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        (controller.ticketReplies[index].type !=
                                                'user'
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ),
                                if (controller
                                        .ticketReplies[index].attachment !=
                                    null) ...{
                                  if (controller.ticketReplies[index]
                                      .attachment!.isNotEmpty) ...{
                                    const SizedBox(height: 3),
                                    LimitedBox(
                                      maxHeight: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: controller
                                                .ticketReplies[index].isPath!
                                            ? Image.file(File(controller
                                                .ticketReplies[index]
                                                .attachment!))
                                            : "${Constants.baseUrl}storage/${controller.ticketReplies[index].attachment}"
                                                .image(isProfile: false),
                                      ),
                                    ),
                                  },
                                },
                                const SizedBox(height: 5),
                                UnconstrainedBox(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      convertUtcToLocal(controller
                                          .ticketReplies[index].createdAt!),
                                      // DateFormat("hh:mm a").format(controller
                                      //     .ticketReplies[index].createdAt!),
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: (controller.ticketReplies[index]
                                                    .type !=
                                                'user'
                                            ? Colors.black87
                                            : Colors.white70),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
            .copyWith(bottom: 8),
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
                      if (controller.attachment.value.path.isEmpty) {
                        return const SizedBox();
                      } else {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                controller.attachment.value,
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
                                    controller.attachment.value = File('');
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
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 3),
                  GlobalTextField(
                    controller: controller.ticketTextController,
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
                            controller.attachment.value =
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
                            controller.attachment.value =
                                File(imageSelected.path);
                          }
                          Get.back();
                        },
                      );
                    },
                  ).decorate(height: kBottomNavigationBarHeight + 8),
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
                if (controller.ticketTextController.text.trim().isEmpty) {
                  Ui.errorGetBar(message: "Please add a message".tr);
                } else {
                  controller.replyToAdmin(Get.arguments);
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
