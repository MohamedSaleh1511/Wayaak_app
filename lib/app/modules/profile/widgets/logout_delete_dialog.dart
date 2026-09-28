import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class LogoutDeleteDialog extends StatelessWidget {
  final String title;
  final String body;
  final String buttonText;
  final VoidCallback buttonTap;
  final Color? primaryBtnColor;
  final Color? secondaryBtnColor;
  const LogoutDeleteDialog({
    super.key,
    required this.title,
    required this.body,
    required this.buttonText,
    required this.buttonTap,
    this.primaryBtnColor,
    this.secondaryBtnColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(30),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title.titleSmall(color: Get.theme.colorScheme.primary),
            const SizedBox(height: 30),
            body.bodyMedium(center: true),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: GlobalButton(
                    onTap: () => Get.back(),
                    text: "Cancel".tr,
                    textColor: secondaryBtnColor ?? Get.theme.colorScheme.error,
                    color: Constants.grey.withOpacity(0.15),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GlobalButton(
                    onTap: buttonTap,
                    text: buttonText,
                    color: primaryBtnColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
