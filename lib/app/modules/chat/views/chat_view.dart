import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/search_card.dart';
import 'package:wayaak/app/core/widgets/shimmers/chat_card_shimmer.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/models/all_chats_model/datum.dart';
import 'package:wayaak/app/routes/app_routes.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Your Messages'.tr.title(color: Colors.black),
        centerTitle: false,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getAllChats();
        },
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              toolbarHeight: kTextTabBarHeight + 20,
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              forceElevated: false,
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SearchCard(
                  text: 'Search'.tr,
                  icon: 'mic',
                  onChanged: (val) {
                    if (val!.isEmpty) {
                      controller.chatsDatumList.value = controller.chatsList;
                    } else {
                      controller.chatsDatumList.value = controller.chatsList
                          .where((e) => e.receiver != null)
                          .toList()
                          .where(
                              (v) => v.receiver!.name!.camelCase!.contains(val))
                          .toList();
                    }
                  },
                ),
              ),
            ),
          ],
          body: Obx(() {
            if (controller.isChatsLoading.value) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (context, index) => const ChatCardShimmer(),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: 5,
              );
            } else {
              if (controller.chatsDatumList.isEmpty) {
                return Center(child: 'No data found'.tr.body());
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          width: double.infinity,
                          child: 'All messages'.tr.subtitle(),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 15)),
                      SliverList.separated(
                        itemBuilder: (context, index) {
                          List<ChatsDatum> chatData = controller.chatsDatumList
                              .where((e) => e.receiver != null)
                              .toList();
                          return InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              controller.socketServices.chatChannelName.value =
                                  "private-chat.${chatData[index].id}";
                              controller.socketServices.checkBroadcastAuth(
                                  "private-chat.${chatData[index].id}");
                              controller.getChatMessages(chatData[index].id!);
                              Get.toNamed(Routes.chatMessages, arguments: [
                                chatData[index].receiver!.avatar,
                                chatData[index].receiver!.name,
                                chatData[index].receiver!.id,
                                chatData[index].id,
                              ]);
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Get.theme.primaryColor,
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      height: 55,
                                      width: 55,
                                      child:
                                          "${Constants.baseUrl}storage/${chatData[index].receiver!.avatar}"
                                              .profileImage,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      '${chatData[index].receiver!.name}'
                                          .titleSmall(
                                        color: Colors.black,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 4),
                                      '${chatData[index].latestMessage!.message}'
                                          .caption(),
                                    ],
                                  ),
                                ),
                              ],
                            ).decorate(padding: 15),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: controller.chatsDatumList
                            .where((e) => e.receiver != null)
                            .length,
                      ),
                    ],
                  ),
                );
              }
            }
          }),
        ),
      ),
    );
  }
}
