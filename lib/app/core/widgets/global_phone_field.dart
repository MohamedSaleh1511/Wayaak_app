import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:wayaak/app/data/constants/constants.dart';

class GlobalPhoneField extends GetWidget {
  final void Function(PhoneNumber)? onChanged;
  final void Function(PhoneNumber?)? onSaved;
  const GlobalPhoneField({super.key, this.onChanged, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        // disableLengthCheck: true,
        showDropdownIcon: false,
        flagsButtonPadding: const EdgeInsets.only(left: 10),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          hintText: 'phone number'.tr,
          counterText: '',
          hintStyle: TextStyle(
            color: Constants.hintText,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        pickerDialogStyle: PickerDialogStyle(
          listTileDivider: const Divider(
            endIndent: 30,
            indent: 30,
            color: Constants.grey,
          ),
          countryCodeStyle: const TextStyle(color: Constants.hintText),
          countryNameStyle: Get.textTheme.titleSmall!.merge(
            TextStyle(
              color: Colors.black,
              fontFamily:
                  (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
              fontWeight: FontWeight.w600,
              fontSize: Get.textTheme.titleSmall!.fontSize!,
            ),
          ),
          searchFieldCursorColor: Get.theme.primaryColor,
          searchFieldInputDecoration: InputDecoration(
            hintText: 'Search Country'.tr,
            hintStyle: const TextStyle(
              color: Constants.hintText,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
        invalidNumberMessage: 'invalid phone number'.tr,

        keyboardType: TextInputType.phone,
        languageCode: Get.locale!.languageCode,
        initialCountryCode: 'EG',
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        onSaved: onSaved,
        validator: (PhoneNumber? val) {
          if (val!.completeNumber.isEmpty) {
            return 'phone number is required'.tr;
          } else if (!val.completeNumber.isPhoneNumber) {
            return 'phone number must be 11 digits'.tr;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
