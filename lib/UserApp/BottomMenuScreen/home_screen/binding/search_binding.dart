import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/search_controller.dart';
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchSalonController());
    }
}
