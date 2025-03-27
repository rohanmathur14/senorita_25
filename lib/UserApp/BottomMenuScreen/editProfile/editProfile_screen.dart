import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/profile_screen/controller/profile_controller.dart';
import 'package:senoritaApp/utils/size_config.dart';
import '../../../helper/appimage.dart';
import '../../../helper/custombtn.dart';
import '../../../helper/getText.dart';
import '../../../utils/color_constant.dart';
import '../../../utils/stringConstants.dart';
import '../../../utils/validation.dart';
import '../../../widget/customTextField.dart';
import 'controller/editProfile_controller.dart';


class EditProfileScreen extends GetView<EditProfileController> {
  EditProfileScreen({key});
  var profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, () {
        Get.back();
      }),
      body: Form(
        key: controller.profileFormKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      _buildUploadImage(context),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomTextField(
                          hintText: "",
                          labelText: registerFullName,
                          auto: AutovalidateMode.onUserInteraction,
                          controller: controller.fullNameController,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Please enter FullName";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomTextField(
                          isReadOnly: profileController.model.value.data!.mobile == null ? false : true,
                          hintText: "",
                          labelText: registerMobileNumber,
                          auto: AutovalidateMode.onUserInteraction,
                          controller: controller.numberController,
                          // isReadOnly: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          textInputType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.length != 10 || (!isValidPhone(value, isRequired: true))) {
                              return "Mobile Number must be of 10 digit";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomTextField(
                          isReadOnly: profileController.model.value.data!.email == null ? false : true,
                          hintText: "",
                          labelText: registerEmailAddress,
                          auto: AutovalidateMode.onUserInteraction,
                          controller: controller.emailController,
                          // validator: (value) {
                          //   if (value == null ||
                          //       (!isValidEmail(value, isRequired: true))) {
                          //     return "Please enter valid email";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => CustomBtn(
                      title: "Save",
                      height: 50,
                      width: double.infinity,
                      color: ColorConstant.onBoardingBack,
                      isLoading: controller.isLoading.value,
                      onTap: () {
                        if (controller.profileFormKey.currentState!.validate()) {
                          controller.uploadApiFunction(context);
                        } else {}
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, Function() onTap) {
    return AppBar(
      backgroundColor: ColorConstant.white,
      elevation: 0,
      leadingWidth: 30,
      automaticallyImplyLeading: false,
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppImages.backIcon,
                      color: Colors.black87,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Center(
                  child: getText(
                      title: "Personal Information",
                      size: 18,
                      fontFamily: interSemiBold,
                      color: ColorConstant.blackColor,
                      fontWeight: FontWeight.w500),
                ),
                Center(
                  child: getText(
                      title: "",
                      size: 16,
                      fontFamily: interSemiBold,
                      color: ColorConstant.blackColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        )
      ],
      centerTitle: true,
    );
  }

  /// Profile Detail Widget
  Widget _buildUploadImage(BuildContext context) {
    String? profileUrl = profileController.getFileName(profileController.model.value.data?.profilePicture).toString();
    return Column(
      children: [
        Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.imgProfileBack,
                  ),
                  fit: BoxFit.cover,
                )),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        border: Border.all(
                          width: 5,
                          color: Colors.black45.withOpacity(0.1),
                        )),
                    child: Stack(
                      children: [
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              controller.showImagePicker(context);
                            },
                            child: Container(
                                height: SizeConfig.screenHeightConstant * 7,
                                width: SizeConfig.screenHeightConstant * 7,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: profileUrl.isEmpty && profileUrl == null
                                    ? Image.asset(
                                        AppImages.person,
                                        scale: 2,
                                      )
                                    : controller.imgFile.value != null
                                        ? ClipOval(
                                            child: Image.file(
                                              File(controller.imgFile.value!.path),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipOval(
                                            child: CachedNetworkImage(
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.cover,
                                              imageUrl: profileUrl,
                                              placeholder: (context, url) => const CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Image.asset(
                                                AppImages.person,
                                                scale: 2,
                                              ),
                                            ),
                                          )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 15,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.storage,
                          Permission.camera,
                        ].request();
                        if (statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted) {
                          controller.showImagePicker(context);
                        } else {
                          print('no permission provided');
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          controller.showImagePicker(context);
                        },
                        child: Container(
                          child: SizedBox(
                              width: SizeConfig.screenHeightConstant * 5,
                              height: SizeConfig.screenHeightConstant * 5,
                              child: Image.asset(
                                AppImages.edit,
                              )),
                        ),
                      ),
                    )),
              ],
            )),
      ],
    );
  }
}
