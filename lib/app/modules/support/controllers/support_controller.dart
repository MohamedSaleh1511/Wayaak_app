import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/faq_model/faq_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/single_ticket_model/single_ticket_model.dart';
import 'package:wayaak/app/data/models/ticket_replies_model/message.dart';
import 'package:wayaak/app/data/models/ticket_replies_model/ticket_replies_model.dart';
import 'package:wayaak/app/data/models/tickets_model/datum.dart';
import 'package:wayaak/app/data/models/tickets_model/tickets_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/support/providers/support_providers.dart';

class SupportController extends GetxController {
  final SupportProviders provider = Get.find<SupportProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isTicketsLoading = false.obs;
  RxList<TicketsDatum> tickets = <TicketsDatum>[].obs;
  getOpenedTickets() async {
    isTicketsLoading.value = true;
    Map<String, dynamic>? data = await provider.getOpenTickets();

    if (data != null) {
      isTicketsLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          tickets.value = (data['data'] as TicketsModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting opened tickets');
        }
      }
    } else {
      isTicketsLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting opened tickets');
    }
  }

  getClosedTickets() async {
    isTicketsLoading.value = true;
    Map<String, dynamic>? data = await provider.getClosedTickets();

    if (data != null) {
      isTicketsLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          tickets.value = (data['data'] as TicketsModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting closed tickets');
        }
      }
    } else {
      isTicketsLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting closed tickets');
    }
  }

  getPendingTickets() async {
    isTicketsLoading.value = true;
    Map<String, dynamic>? data = await provider.getPendingTickets();

    if (data != null) {
      isTicketsLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          tickets.value = (data['data'] as TicketsModel).data!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting pending tickets');
        }
      }
    } else {
      isTicketsLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting pennding tickets');
    }
  }

  RxBool isFaqsLoading = false.obs;
  Rx<FaqModel> faq = FaqModel().obs;
  getFaq() async {
    isFaqsLoading.value = true;
    Map<String, dynamic>? data = await provider.getFAQ();

    if (data != null) {
      isFaqsLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          faq.value = data['data'] as FaqModel;
        } else {
          Ui.errorGetBar(message: 'error occured on getting FAQs');
        }
      }
    } else {
      isFaqsLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting FAQs');
    }
  }

  RxString subject = ''.obs;
  RxString message = ''.obs;
  Rx<File> file = File('').obs;
  Rx<SingleTicketModel> singleTicket = SingleTicketModel().obs;

  createTicket() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.postCreateTicket(
      subject: subject.value,
      message: message.value,
      file: file.value,
    );

    if (data != null) {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          singleTicket.value = (data['data'] as SingleTicketModel);
          Get.back();
          file.value = File('');
          Ui.successGetBar(message: singleTicket.value.message!);
        } else {
          Ui.errorGetBar(
              message: (data['data'] as GlobalResponseModel).message ??
                  'error occured');
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'error occured on creating ticket');
    }
  }

  RxBool isRepliesLoading = false.obs;
  Rx<TicketRepliesModel> ticketReplyModel = TicketRepliesModel().obs;
  RxList<TicketMessage> ticketReplies = <TicketMessage>[].obs;
  getTicketReplies(String ticketNum) async {
    isRepliesLoading.value = true;
    Map<String, dynamic>? data =
        await provider.postTicketReplies(ticketNum: ticketNum);

    if (data != null) {
      isRepliesLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          ticketReplyModel.value = (data['data'] as TicketRepliesModel);
          ticketReplies.value =
              (data['data'] as TicketRepliesModel).data!.messages!;
        } else {
          Ui.errorGetBar(message: data['data'].toString());
        }
      }
    } else {
      isRepliesLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting ticket replies');
    }
  }

  RxBool isReplyLoading = false.obs;
  Rx<File> attachment = File('').obs;
  final TextEditingController ticketTextController = TextEditingController();
  replyToAdmin(String ticketNum) async {
    isReplyLoading.value = true;
    String message = ticketTextController.text;
    File file = attachment.value;
    ticketTextController.text = '';
    attachment.value = File('');
    Map<String, dynamic>? data = await provider.postReplyToAdmin(
      ticketNum: ticketNum,
      message: message,
      file: file,
    );

    if (data != null) {
      isReplyLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          ticketReplies.add(
            TicketMessage(
              message: message,
              type: 'user',
              attachment: file.path,
              isPath: true,
              createdAt: DateTime.now(),
            ),
          );
        } else {
          Ui.errorGetBar(
              message: (data['data'] as GlobalResponseModel).message!);
        }
      }
    } else {
      isReplyLoading.value = false;
      Ui.errorGetBar(message: 'error occured on replying to admin');
    }
  }
}
