import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senoritaApp/CommonScreens/notification/notification_controller.dart';
import 'package:senoritaApp/ScreenRoutes/routes.dart';
import 'package:senoritaApp/api_config/Api_Url.dart';
import 'package:senoritaApp/helper/appbar.dart';
import 'package:senoritaApp/helper/appimage.dart';
import 'package:senoritaApp/helper/getText.dart';
import 'package:senoritaApp/helper/network_image_helper.dart';
import 'package:senoritaApp/utils/color_constant.dart';
import 'package:senoritaApp/utils/my_sperator.dart';
import 'package:senoritaApp/utils/screensize.dart';
import 'package:senoritaApp/utils/stringConstants.dart';
import 'package:senoritaApp/utils/time_format.dart';
import 'package:senoritaApp/widget/no_data_found.dart';

class NotificationScreen extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Notification', () => Get.back()),
      body: Obx(
        () => controller.model != null && controller.model.value.data != null
            ? ListView.separated(
                separatorBuilder: (context, sp) {
                  return Column(
                    children: [
                      ScreenSize.height(19),
                      const MySeparator(
                        height: 1,
                        color: ColorConstant.dot,
                      ),
                      ScreenSize.height(14),
                    ],
                  );
                },
                padding: const EdgeInsets.only(
                    left: 18, right: 17, bottom: 40, top: 10),
                itemCount: controller.model.value.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return notificationWidget(index);
                })
            : noDataFound(),
      ),
    );
  }

  dashedBorderWidget() {
    return DottedBorder(
      borderType: BorderType.RRect,
      dashPattern: [5, 3], // Dash pattern [dash length, gap length]
      color: Colors.black,
      strokeWidth: 1,
      child: Container(
          // width: 1,
          // height: 1, // Adjust height as needed
          ),
    );
  }

  notificationWidget(int index) {
    return GestureDetector(
      onTap: () {
        print(controller.model.value.data![index].userId);
        if (controller.model.value.data![index].userId != null &&
            controller.model.value.data![index].userId.toString().isNotEmpty &&
            controller.route.value == 'user') {
          Get.toNamed(AppRoutes.salonDetailsScreen, arguments: [
            controller.model.value.data![index].userId,
          ]);
        }
      },
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child:
                    controller.model.value.data![index].profilePicture != null
                        ? NetworkImageHelper(
                            img:
                                "${ApiUrls.imgBaseUrl}${controller.model.value.data![index].profilePicture}",
                            height: 55.0,
                            width: 55.0,
                          )
                        : Image.asset(
                            AppImages.profileUsers,
                            height: 55,
                            width: 55,
                          )),
            ScreenSize.width(9),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getText(
                          title: controller.model.value!.data![index].name
                              .toString(),
                          size: 16,
                          fontFamily: interMedium,
                          color: ColorConstant.black3333,
                          fontWeight: FontWeight.w500),
                      getText(
                          title: TimeFormat.convertInTime(controller
                              .model.value!.data![index].createdAt
                              .toString()),
                          size: 14,
                          fontFamily: interMedium,
                          color: ColorConstant.black3333,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  ScreenSize.height(8),
                  Text(
                    controller.model.value.data![index].description.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13,
                        fontFamily: interRegular,
                        color: ColorConstant.redeemTextDark,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
