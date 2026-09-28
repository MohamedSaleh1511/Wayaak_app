import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_textfield.dart';
import 'package:wayaak/app/data/constants/constants.dart';

class SearchCard extends StatelessWidget {
  final String text;
  final String icon;
  final Function(String?)? onChanged;
  final VoidCallback? onTap;
  const SearchCard(
      {super.key,
      required this.text,
      this.onTap,
      required this.icon,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search card',
      child: Material(
        child: Container(
          padding: const EdgeInsetsDirectional.only(end: 10),
          decoration: BoxDecoration(
            color: Constants.softGrey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: GlobalTextField(
            hintText: text,
            prefixIcon: 'search',
            noBorder: true,
            contentPadding: 16,
            suffixText: "Search",
            suffixColor: Get.theme.primaryColor,
            onChanged: onChanged,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
