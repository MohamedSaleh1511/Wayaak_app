import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak/app/modules/home/widgets/drawer_item.dart';
import 'package:wayaak/app/modules/profile/widgets/logout_delete_dialog.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class GlobalDrawer extends GetView<HomeController> {
  const GlobalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return InkWell(
                  onTap: () {
                    controller.scaffoldKey.currentState!.closeDrawer();
                    controller.pageController.animateToPage(
                      3,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                    );
                    controller.currentIndex.value = 3;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: controller.appServices.userName.value.subtitle(),
                      subtitle: UnconstrainedBox(
                        alignment: AlignmentDirectional.centerStart,
                        child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: controller.appServices.userPhone.value
                                .caption()),
                      ),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              '${Constants.baseUrl}storage/${controller.appServices.userImage.value}'
                                  .profileImage,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: 'General'.tr.subtitle(),
              ),
              DrawerItem(
                onTap: () {
                  controller.scaffoldKey.currentState!.closeDrawer();
                  controller.pageController.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeInOut,
                  );
                  controller.currentIndex.value = 3;
                },
                text: 'Profile'.tr,
                icon: 'person',
              ),
              DrawerItem(
                onTap: () {
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.coupons);
                },
                text: 'Coupons'.tr,
                icon: 'ticket',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: 'Other'.tr.subtitle(),
              ),
              DrawerItem(
                onTap: () {
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.language);
                },
                text: 'Language'.tr,
                icon: 'language',
              ),
              DrawerItem(
                onTap: () {
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.savedLocations,
                      arguments: LocationsEntry.none);
                },
                text: 'Saved Locations'.tr,
                icon: 'location',
              ),
              // DrawerItem(
              //   onTap: () {
              //     controller.scaffoldKey.currentState!.closeDrawer();
              //     Get.toNamed(Routes.reviews);
              //   },
              //   text: 'Reviews'.tr,
              //   icon: 'like',
              // ),
              DrawerItem(
                onTap: () {
                  controller.staticController.getAbout();
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.about);
                },
                text: 'About Us'.tr,
                icon: 'About Us',
              ),
              DrawerItem(
                onTap: () {
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.contact);
                },
                text: 'Contact Us'.tr,
                icon: 'phone',
              ),
              DrawerItem(
                onTap: () {
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.support);
                },
                text: 'Support'.tr,
                icon: 'question',
              ),
              DrawerItem(
                onTap: () {
                  controller.staticController.getPrivacyPolicy();
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.privacy);
                },
                text: 'Privacy Policy'.tr,
                icon: 'danger',
              ),
              DrawerItem(
                onTap: () {
                  controller.staticController.getTerms();
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.terms);
                },
                text: 'Terms And Conditions'.tr,
                icon: 'terms',
              ),
              DrawerItem(
                onTap: () {
                  controller.supportController.getFaq();
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.faq);
                },
                text: 'FAQ'.tr,
                icon: 'info',
              ),
              ListTile(
                onTap: () {
                  controller.appServices.removeUserData();
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.dialog(
                    LogoutDeleteDialog(
                      title: "Delete Account".tr,
                      body: "Are you sure you want to delete your account?".tr,
                      buttonText: "Delete".tr,
                      buttonTap: () => controller.deleteAccount(),
                      primaryBtnColor: Constants.accent,
                      secondaryBtnColor: Constants.textColor,
                    ),
                  );
                },
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: UnconstrainedBox(
                    child: 'delete-user'
                        .iconColored(color: Get.theme.colorScheme.error),
                  ),
                ),
                title: 'Delete Account'.tr.subtitle(
                      color: Colors.black,
                      weight: FontWeight.w600,
                    ),
              ),
              Divider(
                color: const Color(0xFF1E252D).withOpacity(0.1),
                height: 20,
                endIndent: 20,
                indent: 20,
              ),
              ListTile(
                onTap: () {
                  controller.scaffoldKey.currentState!.closeDrawer();
                  Get.dialog(
                    LogoutDeleteDialog(
                      title: "Sign out".tr,
                      body: "Are you sure you want to logout?".tr,
                      buttonText: "Logout".tr,
                      buttonTap: () => controller.logout(),
                      primaryBtnColor: Constants.accent,
                      secondaryBtnColor: Constants.textColor,
                    ),
                  );
                },
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: UnconstrainedBox(
                      child: 'logout'
                          .iconColored(color: Get.theme.colorScheme.error)),
                ),
                title: 'Logout'.tr.subtitle(
                      color: Colors.black,
                      weight: FontWeight.w600,
                    ),
              ),
              Divider(
                color: const Color(0xFF1E252D).withOpacity(0.1),
                height: 20,
                endIndent: 20,
                indent: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
