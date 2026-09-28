import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class GlobalAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  const GlobalAppbar({super.key, required this.title , this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title.titleSmall(color: Colors.black),
      centerTitle: false,
      leading: leading ?? IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Transform.flip(
          flipX: Get.locale == const Locale('ar'),
          child: 'Arrow Back'.iconColored(),
        ),
      ),
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight + 5);
}
