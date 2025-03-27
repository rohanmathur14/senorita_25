import 'package:get/get.dart';
import 'package:senoritaApp/ExpertApp/BottomMenuScreen/expert_home_screen/controller/expert_home_controller.dart';
import '../controller/dashboard_controller.dart';

class ExpertDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ExpertDashboardController());
    Get.put(ExpertHomeController());
    // Get.put(ExpertDashboardController());
  }
}
