import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class DrawerItem extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String icon;
  final Widget? trailing;
  const DrawerItem({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.all(0),
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: UnconstrainedBox(
              child: icon.iconColored(color: Get.theme.primaryColor),
            ),
          ),
          title: text.subtitle(
            color: Colors.black,
            weight: FontWeight.w600,
          ),
          trailing: trailing ?? const SizedBox(),
        ),
        Divider(
          color: const Color(0xFF1E252D).withOpacity(0.1),
          height: 20,
          endIndent: 10,
          indent: 10,
        ),
      ],
    );
  }
}
