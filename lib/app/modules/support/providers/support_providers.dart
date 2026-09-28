import 'dart:io';

import 'package:get/get.dart';
import 'package:wayaak/app/data/models/faq_model/faq_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/reply_ticket_model.dart';
import 'package:wayaak/app/data/models/single_ticket_model/single_ticket_model.dart';
import 'package:wayaak/app/data/models/ticket_replies_model/ticket_replies_model.dart';
import 'package:wayaak/app/data/models/tickets_model/tickets_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class SupportProviders extends ApiProvider {
  // NOTE :- Get Open Tickets
  Future<Map<String, dynamic>?> getOpenTickets() async {
    Response res = await get('api/tickets/open', headers: {
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
            : TicketsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get FAQ
  Future<Map<String, dynamic>?> getFAQ() async {
    Response res = await get('driver/faqs', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
            : FaqModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get closed Tickets
  Future<Map<String, dynamic>?> getClosedTickets() async {
    Response res = await get('api/tickets/closed', headers: {
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
            : TicketsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get pending Tickets
  Future<Map<String, dynamic>?> getPendingTickets() async {
    Response res = await get('api/tickets/pending', headers: {
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
            : TicketsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post create Ticket
  Future<Map<String, dynamic>?> postCreateTicket({
    required String subject,
    required String message,
    File? file,
  }) async {
    Response res = await post(
        'api/create_ticket',
        FormData({
          'subject': subject,
          'message': message,
          'file': file!.path.isEmpty
              ? null
              : MultipartFile(file, filename: file.path.split('/').last),
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
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : SingleTicketModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post ticket replies
  Future<Map<String, dynamic>?> postTicketReplies(
      {required String ticketNum}) async {
    Response res = await post('api/get_ticket_replies', {
      'ticket_num': ticketNum
    }, headers: {
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
            : TicketRepliesModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post reply to admin
  Future<Map<String, dynamic>?> postReplyToAdmin({
    required String ticketNum,
    required String message,
    File? file,
  }) async {
    Response res = await post(
        'api/reply',
        FormData({
          'ticket_num': ticketNum,
          'message': message,
          'file': file!.path.isEmpty
              ? null
              : MultipartFile(file, filename: file.path.split('/').last),
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
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : ReplyTicketModel.fromJson(res.body),
      };
    }
  }
}
