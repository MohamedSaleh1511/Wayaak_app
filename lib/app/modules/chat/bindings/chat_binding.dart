import 'package:get/get.dart';
import 'package:wayaak/app/modules/chat/providers/chat_provider.dart';

import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatProvider>(ChatProvider());
    Get.put<ChatController>(ChatController());
  }
}
