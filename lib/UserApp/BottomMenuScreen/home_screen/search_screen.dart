import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senoritaApp/helper/appbar.dart';
import 'package:senoritaApp/helper/appimage.dart';
import 'package:senoritaApp/helper/network_image_helper.dart';
import 'package:senoritaApp/helper/searchbar.dart';
import 'package:senoritaApp/utils/screensize.dart';
import 'package:senoritaApp/widget/no_data_found.dart';
import 'package:waveform_flutter/waveform_flutter.dart';
import '../../../ScreenRoutes/routes.dart';
import '../../../utils/color_constant.dart';
import '../../../utils/stringConstants.dart';
import 'controller/search_controller.dart';

class SearchScreen extends GetView<SearchSalonController> {
  final Stream<Amplitude> amplitudeStream = createRandomAmplitudeStream();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Search', () {
        Get.back();
      }),
      body:  Obx(
            () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: searchBar(
                            readOnly: false,
                            showPrefix: controller.showPrefix.value,
                            clearSearchTap: () {
                              controller.showPrefix.value = false;
                              controller.searchList.clear();
                              controller.isSearch.value = true;
                              controller.searchController.clear();
                            },
                            controller: controller.searchController,
                            onChanged: (val) {
                          
                              if (val.isEmpty) {
                                controller.isSearch.value = true;
                                controller.showPrefix.value = false;
                                controller.searchList.clear();
                              } else {
                                controller.allHomeScreenApiFunction(val);
                                controller.showPrefix.value = true;
                                controller.isSearch.value = false;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              controller.isListening.value ? controller.stopListening() : controller.startListening();
                            },
                            backgroundColor: Color(0xFFFAE4E9),  // Custom color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),  // Fully circular shape
                            ),
                            child: Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color(0xFFFAE4E9)
                            ),height: 20,width: 20,
                                child: Image.asset(AppImages.mic,scale: 3.5,)),
                          ),
                        ),
                      ],
                    )
                  ),
              ScreenSize.height(5),
              controller.isListening.value == true ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.waveform
                      .map((height) => AnimatedContainer(

                    duration: Duration(milliseconds: 100),
                    margin: EdgeInsets.symmetric(horizontal: 4,vertical: 20),
                    width: 8,
                    height: height * 5.0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ))
                      .toList(),
                ):SizedBox(),

              Expanded(
                child: controller.isSearch.value
                      ? noDataFound()
                      : controller.searchList.isEmpty && controller.showPrefix.value
                          ? noDataFound()
                          : ListView.separated(
                              separatorBuilder: (context, sp) {
                                return const SizedBox(
                                  height: 23,
                                );
                              },
                              padding: const EdgeInsets.only(
                                  left: 15, right: 14, top: 20, bottom: 40),
                              shrinkWrap: true,
                              itemCount: controller.searchList.length,
                              physics: const ScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                var model = controller.searchList[index];
                                return searchSalonWidget(model);
                              }),
                ),

            ],


      );}),
    );
  }

  searchSalonWidget(var model) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.salonDetailsScreen, arguments: [
          model['user']['id'].toString(),
          controller.lat.toString(),
          controller.long.toString(),
        ]);
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageHelper(
                img: controller.imgBaseUrl.value +
                    model['user']['profile_picture'].toString(),
                width: 75.0,
                height: 72.0,
              ),
            ),
            ScreenSize.width(16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['user'] != null ? model['user']['name'].toString() : "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: interMedium,
                      color: ColorConstant.blackColorDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ScreenSize.height(4),
                  Text(
                    "${model['user']['distance'].toString()} km Away",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontFamily: interMedium,
                      color: ColorConstant.blackLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
