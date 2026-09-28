import 'package:get/get.dart';
import 'package:wayaak/app/data/models/balance_model/balance_model.dart';
import 'package:wayaak/app/data/models/charge_wallet_model/charge_wallet_model.dart';
import 'package:wayaak/app/data/models/global_response_model.dart';
import 'package:wayaak/app/data/providers/api_provider.dart';
import 'package:wayaak/app/data/services/app_services.dart';

class ProfitProviders extends ApiProvider {
  // NOTE :- Get Account Balance
  Future<Map<String, dynamic>?> getAccountBalance() async {
    Response res = await get('api/balance', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 200)
            ? BalanceModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Charge wallet
  Future<Map<String, dynamic>?> postChargeWallet(double balance) async {
    Response res = await post('api/charge_wallet', {
      'balance': balance,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 200)
            ? ChargeWalletModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }
}
