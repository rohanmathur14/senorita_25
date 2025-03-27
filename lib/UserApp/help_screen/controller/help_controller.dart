import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:senoritaApp/api_config/Api_Url.dart';
import '../../../utils/size_config.dart';

class helpController extends GetxController {
  final url = "".obs;
  final isLoading = true.obs;
  final loadingPercentage = 0.obs;
  late InAppWebViewController webViewController;

  // Reintroducing this variable
  String helpAndTermsString = "";
  String kodagoCardUrl = "";

  @override
  void onInit() {
    super.onInit();

    var arguments = Get.arguments;
    if (arguments != null && arguments.length >= 2) {
      helpAndTermsString = arguments[0];
      kodagoCardUrl = arguments[1];

      if (helpAndTermsString == "termsConditions") {
        url.value = "${ApiUrls.helpSupportBaseUrl}senorita-terms-conditions";
      } else if (helpAndTermsString == "helpSupport") {
        url.value = "${ApiUrls.helpSupportBaseUrl}senorita-help-support";
      } else if (helpAndTermsString == "detail") {
        url.value = kodagoCardUrl;
      }
    }

    SizeConfig().init();
  }

  void changeUrl(String newUrl) {
    url.value = newUrl;
  }
}
