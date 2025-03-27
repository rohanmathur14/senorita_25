import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:senoritaApp/UserApp/BottomMenuScreen/dashboard_screen/controller/dashboard_controller.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/wallet_screen/model/wallet_model.dart';
import 'package:senoritaApp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_config/Api_Url.dart';
import '../../../../utils/showcircledialogbox.dart';
import '../../../../utils/size_config.dart';

class WalletController extends GetxController {
  final id = "".obs; // Initialize with your desired upper value
  var model = WalletModel().obs;
  final isLoading = false.obs;
  @override
  Future<void> onInit() async {
    SizeConfig().init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id.value = prefs.getString("id").toString();
    callApiFunction();
    super.onInit();
  }

  callApiFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (Get.find<DashboardController>().selectedIndex.value == 2 &&
        model == null) {
      showCircleProgressDialog(navigatorKey.currentContext!);
    }
    var headers = {
      'Authorization': 'Bearer ${prefs.getString("token").toString()}'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiUrls.transactionUrl));
    request.fields.addAll({
      'user_id': id.value,
    });
    request.headers.addAll(headers);
    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse)
        .timeout(const Duration(seconds: 60));
    log(response.body);
    if (Get.find<DashboardController>().selectedIndex.value == 2 &&
        model == null) {
      Get.back();
    }
    var dataAll = json.decode(response.body);
    if (response.statusCode == 200) {
      model.value = WalletModel.fromJson(dataAll);
    } else {}
  }
}
