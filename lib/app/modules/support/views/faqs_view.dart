import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/support/controllers/support_controller.dart';

class FaqsView extends GetView<SupportController> {
  const FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'FAQ'.tr),
      body: Obx(
        () => controller.isFaqsLoading.value
            ? Center(
                child:
                    Lottie.asset('assets/lotties/dots-loader.json', width: 80),
              )
            : controller.faq.value.data!.faQs!.isEmpty
                ? Center(child: 'No data found'.tr.bodyMedium())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemCount: controller.faq.value.data!.faQs!.length,
                    itemBuilder: (context, index) => ExpansionTile(
                      title: controller.faq.value.data!.faQs![index].question!
                          .subtitle(),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      childrenPadding: const EdgeInsets.all(12),
                      children: [
                        controller.faq.value.data!.faQs![index].answer!
                            .bodyMedium(),
                      ],
                    ).decorate(padding: 2),
                  ),
      ),
    );
  }
}
