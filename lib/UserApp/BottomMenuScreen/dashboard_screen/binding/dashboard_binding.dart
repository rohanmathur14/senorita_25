import 'package:get/get.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/change_location/change_location_controller.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/wallet_screen/controller/wallet_controller.dart';
import '../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(DashboardController());
    Get.put( WalletController());
    Get.put( ChangeLocationController());
  }
}
