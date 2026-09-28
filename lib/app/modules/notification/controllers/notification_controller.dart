import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/models/notifications_model/notification.dart';
import 'package:wayaak/app/data/models/notifications_model/notifications_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak/app/modules/notification/providers/notifications_provider.dart';
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';
import 'package:wayaak/app/modules/support/controllers/support_controller.dart';

class NotificationController extends GetxController {
  final NotificationsProviders provider = Get.find<NotificationsProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final OrdersController ordersController = Get.find<OrdersController>();
  final HomeController homeController = Get.find<HomeController>();
  final SupportController supportController = Get.find<SupportController>();

  RxBool isNotificationsLoading = false.obs;
  RxList<NotificationData> notificationsList = <NotificationData>[].obs;
  getNotifications() async {
    isNotificationsLoading.value = true;
    Map<String, dynamic>? data = await provider.getNotifications();
    isNotificationsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          print("#######@@@@@");
          print(data['data']);
          notificationsList.value =
              (data['data'] as NotificationsModel).data!.notifications!;
        } else {
          GlobalResponseModel model = (data['data'] as GlobalResponseModel);
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  clearNotifications() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.clearNotifications();

    // Safely close the dialog if it's still open
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          notificationsList.value = [];
        } else {
          GlobalResponseModel model = (data['data'] as GlobalResponseModel);
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  markAsRead(String id) {
    provider.markAsRead(id);
  }

  @override
  void onReady() {
    super.onReady();
    getNotifications();
  }
}
