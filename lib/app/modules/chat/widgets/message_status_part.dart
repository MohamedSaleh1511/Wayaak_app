import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/chat/controllers/chat_controller.dart';

class MessageStatusPart extends GetWidget<ChatController> {
  final MesssageStatus status;
  const MessageStatusPart({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    if (status == MesssageStatus.loading) {
      return const SizedBox();
    } else if (status == MesssageStatus.failed) {
      return "Unable to send the message".tr.overline(color: Constants.accent);
    } else {
      return const SizedBox();
    }
    // });
  }
}
