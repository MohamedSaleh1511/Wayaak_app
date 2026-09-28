import 'package:get/get.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/models/balance_model/balance_model.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/profits/providers/profit_providers.dart';

class ProfitsController extends GetxController {
  final ProfitProviders provider = Get.find<ProfitProviders>();
  final AppServices appServices = Get.find<AppServices>();

  RxBool isBalanceLoading = false.obs;
  Rx<BalanceModel> balanceModel = BalanceModel().obs;
  getAccountBalance() async {
    isBalanceLoading.value = true;
    Map<String, dynamic>? data = await provider.getAccountBalance();
    if (data != null) {
      isBalanceLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          balanceModel.value = data['data'] as BalanceModel;
        } else {
          Ui.errorGetBar(message: 'error occured on getting account balance');
        }
      }
    } else {
      isBalanceLoading.value = false;
      Ui.errorGetBar(message: 'error occured  on getting account balance');
    }
  }

  @override
  void onReady() {
    getAccountBalance();
    super.onReady();
  }
}
