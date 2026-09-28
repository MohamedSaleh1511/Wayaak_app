import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/support/controllers/support_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class TicketsView extends GetView<SupportController> {
  const TicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Tickets'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Obx(
            () {
              if (controller.isTicketsLoading.value) {
                return Center(
                  child: Lottie.asset('assets/lotties/dots-loader.json',
                      width: 80),
                );
              } else {
                if (controller.tickets.isEmpty) {
                  return "No data found".tr.body();
                } else {
                  return ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      title:
                          "${"Ticket Number".tr}: ${controller.tickets[index].ticketNum!}"
                              .titleSmall(),
                      subtitle: controller.tickets[index].subject!
                          .bodyMedium(maxLines: 1),
                      onTap: () {
                        controller.ticketReplies.value = [];
                        controller.getTicketReplies(
                            controller.tickets[index].ticketNum!);
                        Get.toNamed(Routes.ticketChat,
                            arguments: controller.tickets[index].ticketNum!);
                      },
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: controller.tickets[index].status == 'open'
                              ? Colors.green.withOpacity(0.1)
                              : controller.tickets[index].status == 'closed'
                                  ? Constants.accent.withOpacity(0.1)
                                  : Get.theme.colorScheme.secondary
                                      .withOpacity(0.1),
                        ),
                        child: (controller.tickets[index].status == 'open'
                                ? "Opened".tr
                                : controller.tickets[index].status == 'closed'
                                    ? "Closed".tr
                                    : "Pending".tr)
                            .caption(
                                color:
                                    controller.tickets[index].status == 'open'
                                        ? Colors.green
                                        : controller.tickets[index].status ==
                                                'closed'
                                            ? Constants.accent
                                            : Get.theme.colorScheme.secondary),
                      ),
                    ).decorate(padding: 5),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemCount: controller.tickets.length,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
