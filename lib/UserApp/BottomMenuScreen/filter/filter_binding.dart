import 'package:get/get.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/filter/filter_controller.dart';

class FilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FilterController());
    // Get.lazyPut(() => FilterController());
  }
}
