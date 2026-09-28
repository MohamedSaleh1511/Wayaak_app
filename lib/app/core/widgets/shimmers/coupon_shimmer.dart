import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/coupons/widgets/coupon_clipper.dart';
import 'package:wayaak/app/modules/coupons/widgets/coupon_painter.dart';

class CouponCardShimmer extends StatelessWidget {
  const CouponCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.flip(
          flipX: Get.locale == const Locale('ar'),
          child: ClipPath(
            clipper: CouponClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        Transform.flip(
          flipX: Get.locale == const Locale('ar'),
          child: CustomPaint(
            painter:
                CouponPainter(strokeColor: const Color.fromARGB(21, 0, 0, 0)),
            child: const SizedBox(
              height: 130,
              width: double.infinity,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, c) {
            return Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 130,
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: c.maxWidth * 0.35 + 15,
                    height: 130,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: c.maxWidth * 0.3,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).shimmer(),
                        const SizedBox(height: 5),
                        Container(
                          width: c.maxWidth * 0.25,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).shimmer(),
                      ],
                    ),
                  ),
                  Container(
                    height: 96,
                    decoration: DottedDecoration(
                      color: Colors.black,
                      strokeWidth: 1,
                      shape: Shape.line,
                      linePosition: LinePosition.right,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      height: 130,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: c.maxWidth * 0.27,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 18,
                                ),
                                decoration: DottedDecoration(
                                  color: Constants.accent,
                                  strokeWidth: 1,
                                  shape: Shape.box,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ).shimmer(),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: c.maxWidth * 0.4,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ).shimmer(),
                            ],
                          ),
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Container(
                              width: 35,
                              height: 35,
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ).shimmer(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
