import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/dashboard_screen/controller/dashboard_controller.dart';
import 'package:senoritaApp/helper/appbar.dart';
import 'package:senoritaApp/helper/network_image_helper.dart';
import '../../../ScreenRoutes/routes.dart';
import '../../../utils/color_constant.dart';
import '../../../utils/stringConstants.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/home_screen/model/home_category_model.dart';


class AllCategoryScreen extends StatefulWidget {


  const AllCategoryScreen({
    Key? key,

  }) : super(key: key);

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:  AppBar(
         centerTitle: true,
          title: Text('Categories',style: TextStyle(fontWeight: FontWeight.w500),),
          automaticallyImplyLeading: false,
        ),

      body: Obx(() {
        var categories = controller.categoryModel.value.data ?? [];
        var baseUrl = controller.categoryModel.value.baseUrl ?? '';

        if (categories.isEmpty) {
          return const Center(child: Text("No categories available"));
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.singleCategoryListScreen,
                    arguments: [
                      categories[index].id.toString(),
                      categories[index].name.toString()
                    ],
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, -1),
                        blurRadius: 10,
                        color: ColorConstant.blackColor.withOpacity(.2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NetworkImageHelper(
                        img: "$baseUrl/${categories[index].iconImage}",
                        width: 50.0,
                        height: 50.0,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        categories[index].name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorConstant.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: interMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
