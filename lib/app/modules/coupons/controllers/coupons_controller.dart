import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/coupons_model/coupon.dart';
import 'package:wayaak/app/data/models/coupons_model/coupons_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/coupons/providers/coupons_provider.dart';

class CouponsController extends GetxController {
  final CouponsProviders provider = Get.find<CouponsProviders>();
  final AppServices appServices = Get.find<AppServices>();

  RxBool isCouponsLoading = false.obs;
  RxList<Coupon> couponsList = <Coupon>[].obs;
  getCoupons() async {
    isCouponsLoading.value = true;
    Map<String, dynamic>? data = await provider.getCoupons();
    isCouponsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          couponsList.value = (data['data'] as CouponsModel).data!.coupons!;
        } else {
          Ui.errorGetBar(message: 'error occured on getting coupons');
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured on getting coupons');
    }
  }

  @override
  void onReady() {
    super.onReady();
    getCoupons();
  }
}
