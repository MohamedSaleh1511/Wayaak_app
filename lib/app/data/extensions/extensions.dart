import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/constants/constants.dart';

extension CustomBoxDecoration on Widget {
  Widget decorate({
    Color? color,
    double? radius,
    double? width,
    double? height,
    double? padding,
    bool shadow = true,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding:
          padding == null ? const EdgeInsets.all(0) : EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 18)),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.03),
                  blurRadius: 13,
                  offset: const Offset(0, 13),
                ),
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.02),
                  blurRadius: 17,
                  offset: const Offset(0, 28),
                ),
              ]
            : [],
      ),
      child: this,
    );
  }

  Widget dialogTransition(Animation<double> animation) {
    Tween<Offset> tween;
    if (animation.status == AnimationStatus.reverse) {
      tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
    } else {
      tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
    }

    return SlideTransition(
      position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutBack)),
      child: this,
    );
  }

  Widget shimmer({int? duration, Color? highlightColor, Color? baseColor}) =>
      Shimmer.fromColors(
        period: Duration(milliseconds: duration ?? 1500),
        highlightColor: highlightColor ?? Colors.grey[50]!,
        baseColor: baseColor ?? Colors.grey[200]!,
        child: this,
      );
}

extension CustomInputDecoration on InputDecoration {
  static InputDecoration decorate(
      {required String hintText,
      String? prefixIcon,
      String? suffixIcon,
      String? suffixText,
      bool? noBorder,
      double? contentPadding,
      Color? suffixColor,
      VoidCallback? onSuffixTap,
      bool? filled = true}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 13,
        color: Constants.hintText,
        fontFamily: Get.locale == const Locale('ar') ? 'Almarai' : 'Poppin',
      ),
      prefixIcon: prefixIcon != null
          ? UnconstrainedBox(
              child: prefixIcon.iconColored(color: Constants.hintText))
          : const SizedBox(),
      prefixIconConstraints: prefixIcon != null
          ? const BoxConstraints.expand(width: 55, height: 55)
          : const BoxConstraints.expand(width: 20, height: 20),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: EdgeInsets.all(contentPadding ?? 22),
      suffixIconColor: Get.theme.colorScheme.secondary,
      enabledBorder: OutlineInputBorder(
        borderSide: noBorder!
            ? BorderSide.none
            : const BorderSide(color: Constants.grey, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      border: OutlineInputBorder(
        borderSide: noBorder
            ? BorderSide.none
            : const BorderSide(color: Constants.grey, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: noBorder
            ? BorderSide.none
            : const BorderSide(color: Constants.secondary, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      suffixIconConstraints: (suffixIcon == null)
          ? const BoxConstraints.expand(width: 60, height: 22)
          : null,
      suffix: (suffixText == null)
          ? null
          : InkWell(
              onTap: onSuffixTap,
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: suffixText.bodyMedium(
                  color: suffixColor ?? Constants.accent,
                  center: true,
                ),
              ),
            ),
      suffixIcon: (suffixIcon == null)
          ? null
          : IconButton(
              onPressed: onSuffixTap,
              icon: UnconstrainedBox(
                child:
                    suffixIcon.iconColored(color: Constants.accent, size: 24),
              ),
            ),
    );
  }
}

extension CustomOrderStatus on OrderStatus {
  Widget getStatus() {
    if (this == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Constants.accent.withOpacity(0.1),
        ),
        child:
            name.tr.caption(color: Constants.accent, weight: FontWeight.w500),
      );
    } else if (this == OrderStatus.delivered) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Constants.green.withOpacity(0.1),
        ),
        child: name.tr.caption(color: Constants.green, weight: FontWeight.w500),
      );
    } else if (this == OrderStatus.driverAccepted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.theme.colorScheme.secondary.withOpacity(0.1),
        ),
        child: name.tr.caption(
            color: Get.theme.colorScheme.secondary, weight: FontWeight.w500),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Constants.softGrey,
        ),
        child: name.tr.caption(weight: FontWeight.w500),
      );
    }
  }
}

extension CustomIconProvider on String {
  // Widget icon({Color? color, double? size}) => ImageIcon(
  //       Svg('assets/icons/$this.svg'),
  //       color: color ?? Colors.black,
  //       size: size ?? 24,
  //     );
  Widget iconColored({double? size, Color? color}) => SvgPicture.asset(
        'assets/icons/$this.svg',
        width: size ?? 24,
        height: size ?? 24,
        colorFilter: color == null
            ? const ColorFilter.mode(Colors.white, BlendMode.dst)
            : ColorFilter.mode(color, BlendMode.srcATop),
      );
}

extension CustomTextStyles on String {
  Text get displayMedium => Text(
        this,
        style: Get.textTheme.displayMedium!.merge(
          TextStyle(
            color: Get.theme.primaryColor,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
          ),
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      );

  Text get displaySmall => Text(
        this,
        style: Get.textTheme.displaySmall!.merge(
          TextStyle(
            color: Get.theme.primaryColor,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
          ),
        ),
      );

  Text headline({Color? color}) => Text(
        this,
        style: Get.textTheme.headlineMedium!.merge(
          TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Get.theme.primaryColor,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
            fontSize: Get.textTheme.headlineMedium!.fontSize! - 2,
          ),
        ),
      );

  Text title({Color? color, FontWeight? weight, TextAlign? align}) => Text(
        this,
        style: Get.textTheme.titleLarge!.merge(
          TextStyle(
            color: color ?? Get.theme.primaryColor,
            fontWeight: weight ?? FontWeight.bold,
            fontSize: Get.textTheme.titleLarge!.fontSize! - 2,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
          ),
        ),
        textAlign: align ?? TextAlign.start,
      );
  Text titleSmall({Color? color, FontWeight? weight}) => Text(
        this,
        style: Get.textTheme.titleMedium!.merge(
          TextStyle(
            color: color ?? Get.theme.primaryColor,
            fontWeight: weight ?? FontWeight.bold,
            fontSize: Get.textTheme.titleMedium!.fontSize! - 2,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
          ),
        ),
      );

  Text subtitle({Color? color, FontWeight? weight}) => Text(
        this,
        style: Get.textTheme.titleSmall!.merge(
          TextStyle(
            color: color ?? Colors.black,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
            fontWeight: weight ?? FontWeight.w600,
            fontSize: Get.textTheme.titleSmall!.fontSize!,
          ),
        ),
      );

  Text body(
          {Color? color,
          bool center = false,
          FontWeight weight = FontWeight.normal}) =>
      Text(
        this,
        style: Get.textTheme.bodyLarge!.merge(
          TextStyle(
            color: color ?? Constants.textColor,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
            height: 1.5,
            fontWeight: weight,
          ),
        ),
        softWrap: true,
        textAlign: center ? TextAlign.center : TextAlign.start,
      );
  Text bodyMedium({
    Color? color,
    bool center = false,
    FontWeight weight = FontWeight.normal,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Text(
        replaceAll(r'\n', '\n'), // <-- هنا
        style: Get.textTheme.bodyMedium!.merge(
          TextStyle(
            color: color ?? Constants.textColor,
            overflow: overflow,
            fontFamily:
            (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
            height: 1.5,
            fontWeight: weight,
          ),
        ),
        maxLines: maxLines,
        softWrap: true,
        textAlign: center ? TextAlign.center : TextAlign.start,
      );


  Text caption({Color? color, FontWeight? weight}) => Text(
        this,
        style: Get.textTheme.bodySmall!.merge(
          TextStyle(
            color: color ?? Constants.textColor,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
            fontWeight: weight ?? FontWeight.normal,
          ),
        ),
      );

  Text overline({Color? color}) => Text(
        this,
        style: Get.textTheme.labelSmall!.merge(
          TextStyle(
            color: color ?? Constants.textColor,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
          ),
        ),
      );

  Text button({Color? color, TextDecoration? decor}) => Text(
        this,
        style: Get.textTheme.labelLarge!.merge(
          TextStyle(
            color: color ?? Get.theme.primaryColor,
            fontWeight: FontWeight.bold,
            decoration: decor,
            fontFamily:
                (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
          ),
        ),
      );
}

extension CustomImage on String {
  Widget image({bool? isProfile = true, bool? isTap = false}) =>
      CachedNetworkImage(
        imageUrl: this,
        alignment: Alignment.center,
        fit: isTap! ? BoxFit.contain : BoxFit.cover,
        placeholder: (context, s) => Lottie.asset(
          'assets/lotties/image-loader.json',
          alignment: Alignment.center,
        ),
        errorWidget: (context, s, v) => (isProfile!)
            ? Image.asset('assets/images/profile.png')
            : Image.asset('assets/images/logo.png'),
      );
  Widget get profileImage => CachedNetworkImage(
        imageUrl: this,
        alignment: Alignment.center,
        fit: BoxFit.cover,
        placeholder: (context, s) => Lottie.asset(
          'assets/lotties/image-loader.json',
          alignment: Alignment.center,
        ),
        errorWidget: (context, s, v) =>
            Image.asset('assets/images/profile.png'),
      );
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }

  Offset get offset {
    RenderBox renderObject = currentContext?.findRenderObject() as RenderBox;
    return renderObject.localToGlobal(Offset.zero);
  }
}
