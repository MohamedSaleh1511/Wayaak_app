import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/core/helpers/helpers.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/home/widgets/drawer_item.dart';
import 'package:wayaak/app/modules/profile/widgets/logout_delete_dialog.dart';
import 'package:wayaak/app/routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'My Profile'.tr.title(color: Colors.black),
        centerTitle: false,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        actions: [
          IconButton.filled(
            onPressed: () => Get.toNamed(Routes.notification),
            icon: 'notification'.iconColored(color: Colors.white),
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getProfileData();
          controller.getAccountBalance();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15)
              .copyWith(bottom: kBottomNavigationBarHeight + 45),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    if (controller.isProfileLoading.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: UnconstrainedBox(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              width: Get.width * 0.4,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).shimmer(),
                          ),
                          subtitle: UnconstrainedBox(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              width: Get.width * 0.3,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).shimmer(),
                          ),
                          leading: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              )).shimmer(),
                        ),
                      );
                    } else {
                      if (controller.profileModel.value.status == null) {
                        return const SizedBox();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: controller
                                .profileModel.value.data!.user!.name!
                                .subtitle(),
                            subtitle: UnconstrainedBox(
                              alignment: AlignmentDirectional.centerStart,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: controller
                                    .profileModel.value.data!.user!.phone!
                                    .caption(),
                              ),
                            ),
                            leading: controller.profileModel.value.data!.user!
                                        .avatar ==
                                    null
                                ? Image.asset('assets/images/profile.png')
                                : AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          '${Constants.baseUrl}storage/${controller.profileModel.value.data!.user!.avatar}'
                                              .profileImage,
                                    ),
                                  ),
                          ),
                        );
                      }
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: 'General'.tr.subtitle(),
                ),
                DrawerItem(
                  onTap: () {},
                  text: 'Account Balance'.tr,
                  icon: 'wallet',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () {
                          if (controller.isBalanceLoading.value) {
                            return '0.0 ${controller.appServices.userCurrencyCode.value.tr}'
                                .bodyMedium(
                              weight: FontWeight.w600,
                              color: Get.theme.primaryColor,
                            );
                          } else {
                            if (controller.balanceModel.value.data == null) {
                              return '0.0 ${controller.appServices.userCurrencyCode.value.tr}'
                                  .bodyMedium(
                                weight: FontWeight.w600,
                                color: Get.theme.primaryColor,
                              );
                            } else {
                              return '${controller.balanceModel.value.data!.balance} ${controller.appServices.userCurrencyCode.value.tr}'
                                  .bodyMedium(
                                weight: FontWeight.w600,
                                color: Get.theme.primaryColor,
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      GlobalButton(
                        onTap: () {
                          Get.generalDialog(
                            barrierDismissible: true,
                            barrierLabel: 'charge wallet',
                            transitionBuilder: (context, animation,
                                    secondaryAnimation, child) =>
                                child.dialogTransition(animation),
                            transitionDuration:
                                const Duration(milliseconds: 800),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              insetPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 10),
                                    'Charge your Wallet'.tr.titleSmall(),
                                    const SizedBox(height: 30),
                                    Form(
                                      key: controller.walletFormKey,
                                      child: GlobalTextField(
                                        controller: controller.walletController,
                                        hintText: "Enter amount".tr,
                                        prefixIcon: 'chargewallet',
                                        textInputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          NumberInputFormatter(), // Custom formatter
                                        ],
                                        inputType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        suffixText: controller.appServices
                                            .userCurrencyCode.value.tr,
                                        onSaved: (val) {},
                                        validator: (String? val) {
                                          if (val!.isEmpty) {
                                            return 'Please add amount'.tr;
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GlobalButton(
                                            onTap: () => Get.back(),
                                            text: "Cancel".tr,
                                            color: Constants.grey
                                                .withOpacity(0.15),
                                            textColor: Constants.accent,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: GlobalButton(
                                            onTap: () {
                                              if (controller
                                                  .walletFormKey.currentState!
                                                  .validate()) {
                                                Get.back();
                                                controller.handlingChargeWallet(
                                                  totalPrice: double.parse(
                                                    controller
                                                        .walletController.text,
                                                  ),
                                                );
                                              }
                                            },
                                            text: "Charge".tr,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        text: 'Add'.tr,
                        icon: 'Plus',
                        height: 48,
                      ),
                    ],
                  ),
                ),
                DrawerItem(
                  onTap: () => Get.toNamed(Routes.orders),
                  text: 'orders'.tr,
                  icon: 'box',
                  trailing:
                      '${controller.ordersController.orderDatumList.length} ${"Orders".tr}'
                          .caption(
                    color: Colors.black,
                    weight: FontWeight.bold,
                  ),
                ),
                DrawerItem(
                  onTap: () => Get.toNamed(Routes.coupons),
                  text: 'Coupons'.tr,
                  icon: 'ticket',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: 'Other'.tr.subtitle(),
                ),
                DrawerItem(
                  onTap: () {
                    controller.editNameController.text =
                        controller.appServices.userName.value;
                    controller.editEmailController.text =
                        controller.appServices.userEmail.value;
                    controller.birthDateController.text =
                        controller.appServices.userBirthDate.value;
                    controller.gender.value =
                        controller.appServices.userGender.value;
                    Get.toNamed(Routes.editProfile);
                  },
                  text: 'Edit Profile'.tr,
                  icon: 'edit',
                ),
                DrawerItem(
                  onTap: () {
                    controller.editNameController.text =
                        controller.appServices.userName.value;
                    controller.editEmailController.text =
                        controller.appServices.userEmail.value;
                    controller.birthDateController.text =
                        controller.appServices.userBirthDate.value;
                    controller.gender.value =
                        controller.appServices.userGender.value;
                    Get.toNamed(Routes.changePass);
                  },
                  text: 'Change Password'.tr,
                  icon: 'change',
                ),
                // Obx(
                //   () {
                //     return DrawerItem(
                //       onTap: () {
                //         controller.appServices.notificationsOn.value =
                //             !controller.appServices.notificationsOn.value;
                //         controller.appServices.saveNotificationOn(
                //             controller.appServices.notificationsOn.value);
                //       },
                //       text: 'Notifications'.tr,
                //       icon: 'notification',
                //       trailing: Switch(
                //         value: controller.appServices.notificationsOn.value,
                //         activeTrackColor: Colors.green,
                //         inactiveTrackColor: Colors.red,
                //         trackOutlineColor:
                //             const WidgetStatePropertyAll(Colors.transparent),
                //         onChanged: (value) {
                //           controller.appServices.notificationsOn.value = value;
                //           controller.appServices.saveNotificationOn(value);
                //         },
                //       ),
                //     );
                //   },
                // ),
                DrawerItem(
                  onTap: () {
                    Get.toNamed(Routes.savedLocations,
                        arguments: LocationsEntry.none);
                  },
                  text: 'Saved Locations'.tr,
                  icon: 'location',
                ),
                // DrawerItem(
                //   onTap: () {
                //     Get.toNamed(Routes.reviews);
                //   },
                //   text: 'Reviews'.tr,
                //   icon: 'like',
                // ),
                DrawerItem(
                  onTap: () {
                    Get.toNamed(Routes.support);
                  },
                  text: 'Support'.tr,
                  icon: 'question',
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    Get.dialog(
                      LogoutDeleteDialog(
                        title: "Delete Account".tr,
                        body:
                            "Are you sure you want to delete your account?".tr,
                        buttonText: "Delete".tr,
                        buttonTap: () =>
                            controller.homeController.deleteAccount(),
                        primaryBtnColor: Constants.accent,
                        secondaryBtnColor: Constants.textColor,
                      ),
                    );
                  },
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    Get.dialog(
                      LogoutDeleteDialog(
                        title: "Logout".tr,
                        body: "Are you sure you want to logout?".tr,
                        buttonText: "Logout".tr,
                        buttonTap: () {
                          Get.back();
                          controller.homeController.logout();
                        },
                        primaryBtnColor: Constants.accent,
                        secondaryBtnColor: Constants.textColor,
                      ),
                    );
                  },
                  leading: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.error.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: UnconstrainedBox(
                      child: 'logout'
                          .iconColored(color: Get.theme.colorScheme.error),
                    ),
                  ),
                  title: 'Log Out'.tr.subtitle(
                        color: Colors.black,
                        weight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
