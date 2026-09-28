import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/home/widgets/global_drawer.dart';
import 'package:wayaak/app/routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      extendBody: true,
      drawer: const GlobalDrawer(),
      body: PageView.builder(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => controller.pages[index],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.colorScheme.secondary,
        onPressed: () async {
          if (!(await Permission.location.isGranted)) {
            await Permission.location.request();
          }
          Get.toNamed(Routes.addOrder);
        },
        shape: const CircleBorder(),
        child: 'Plus'.iconColored(color: Colors.white),
      ),
      bottomNavigationBar: Obx(
        () {
          return BottomAppBar(
            notchMargin: 8,
            padding: const EdgeInsets.all(0.0),
            shape: const CircularNotchedRectangle(),
            elevation: 45,
            shadowColor: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    controller.pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                    );
                    controller.currentIndex.value = 0;
                  },
                  icon: (controller.currentIndex.value == 0)
                      ? 'home-fill'.iconColored(color: Get.theme.primaryColor)
                      : 'home'.iconColored(),
                ),
                IconButton(
                  onPressed: () {
                    controller.pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                    );
                    controller.currentIndex.value = 1;
                  },
                  icon: (controller.currentIndex.value == 1)
                      ? 'box-fill'.iconColored()
                      : 'box'.iconColored(),
                ),
                const SizedBox(),
                IconButton(
                  onPressed: () {
                    controller.pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                    );
                    controller.currentIndex.value = 2;
                  },
                  icon: (controller.currentIndex.value == 2)
                      ? 'message-fill'
                          .iconColored(color: Get.theme.primaryColor)
                      : 'message'.iconColored(),
                ),
                IconButton(
                  onPressed: () {
                    controller.pageController.animateToPage(
                      3,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                    );
                    controller.currentIndex.value = 3;
                  },
                  icon: (controller.currentIndex.value == 3)
                      ? 'person-fill'.iconColored(color: Get.theme.primaryColor)
                      : 'person'.iconColored(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
