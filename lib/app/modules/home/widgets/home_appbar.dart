import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String userName;
  const HomeAppbar({super.key, this.scaffoldKey, required this.userName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: scaffoldKey == null
          ? const SizedBox()
          : IconButton(
              onPressed: () => scaffoldKey!.currentState!.openDrawer(),
              icon: 'menu'.iconColored(),
              style: IconButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          (TimeOfDay.now().period == DayPeriod.pm
                  ? 'Good Evening'
                  : 'Good Morning')
              .tr
              .caption(color: Colors.black54),
          userName.subtitle(
            color: Colors.black,
            weight: FontWeight.w600,
          ),
        ],
      ),
      actions: [
        scaffoldKey == null
            ? const SizedBox()
            : IconButton(
                onPressed: () => Get.toNamed(Routes.notification),
                icon: 'notification'.iconColored(),
                style: IconButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight + 5);
}
