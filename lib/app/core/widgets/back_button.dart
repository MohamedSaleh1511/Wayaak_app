import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class GlobalBackButton extends StatelessWidget {
  final bool isSubsDonePage;
  const GlobalBackButton({super.key, this.isSubsDonePage = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (isSubsDonePage) {
              Get.back();
            }
            if (Get.isSnackbarOpen) {
              Get.closeCurrentSnackbar();
            }
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
            Get.back();
          },
          icon: (Get.locale == const Locale('ar'))
              ? Transform.rotate(
                  angle: pi,
                  child: 'Arrow Back'.iconColored(),
                )
              : 'Arrow Back'.iconColored(),
        ),
      ],
    );
  }
}
