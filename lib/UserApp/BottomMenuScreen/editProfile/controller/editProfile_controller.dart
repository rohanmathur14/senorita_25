import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senoritaApp/CommonScreens/otp_screen/controller/otp_controller.dart';
import 'package:senoritaApp/helper/getText.dart';
import 'package:senoritaApp/utils/color_constant.dart';
import 'package:senoritaApp/utils/stringConstants.dart';
import 'package:senoritaApp/utils/toast.dart';
import 'package:senoritaApp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../ScreenRoutes/routes.dart';
import '../../../../api_config/ApiConstant.dart';
import '../../../../api_config/Api_Url.dart';
import '../../../../utils/showcircledialogbox.dart';
import '../../../../utils/size_config.dart';
import '../../../../widget/error_box.dart';
import '../../dashboard_screen/controller/dashboard_controller.dart';
import '../../profile_screen/controller/profile_controller.dart';
import '../../../../api_config/ApiConstant.dart';
import '../../../../api_config/Api_Url.dart';
import '../../../../utils/size_config.dart';
import 'dart:io';



class EditProfileController extends GetxController {
  final imgFile = Rx<File?>(null);
  RxString imgUrl = ''.obs;
  final fullNameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final profileFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  String Id = "";
  String token = "";
  var profileController = Get.find<ProfileController>();

  @override
  Future<void> onInit() async {
    SizeConfig().init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Id = prefs.getString("id").toString();
    token = prefs.getString("token").toString();
    setValues();
    super.onInit();
  }

  validation() async {
    if (profileFormKey.currentState!.validate()) {
      //loginApiFunction();
    }
  }

  void resetValues() {
    fullNameController.clear();
    fullNameController.text = "";

    numberController.clear();
    numberController.text = "";

    emailController.clear();
    emailController.text = "";

  }

  setValues() {
    if (profileController.model.value != null &&
        profileController.model.value.data != null) {
      fullNameController.text = profileController.model.value.data!.name ?? "";
      numberController.text = profileController.model.value.data!.mobile ?? "";
      emailController.text = profileController.model.value.data!.email ?? '';
      imgUrl = "${profileController.imgUrl}".obs;
    }
  }

  uploadApiFunction(BuildContext context) async {
    Utils.hideKeyboard();
    showCircleProgressDialog(context);
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUrls.updateUserProfile + "/" + Id));
    request.fields.addAll({
      'name': fullNameController.text.toString(),
      'email': emailController.text.toString(),
      'mobile': numberController.text.toString(),
    });

    request.headers.addAll(headers);
    if (imgFile.value == null) {
    } else {
      final file = await http.MultipartFile.fromPath(
          'profile_picture', imgFile.value!.path);
      request.files.add(file);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    Get.back();
    log(response.body);
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      if (result['success'] == true) {
        if (result['verify_otp_popup'] != null &&
            result['verify_otp_popup'].toString() == '1') {
          Get.toNamed(AppRoutes.otpScreen, arguments: [
            "update",
            numberController.text.toString(),
            profileController.model != null &&
                    profileController.model.value.data != null
                ? profileController.model.value.data!.id
                : ''
          ])!
              .then((val) {
            Get.back();
          });
          Get.find<OtpController>().onInit();
        } else {
          Get.back();
        }
        // profileController.profileApiFunction();
      } else {
        print('object');
        showErrorMessageDialog(context, result["message"].toString());
      }
    } else {
      showErrorMessageDialog(context, result["message"].toString());
    }
  }

  ///profile image --*&()

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        elevation: 0,
        context: context,
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        builder: (builder) {
          return SizedBox(
            height: 150,
            child: Center(
              child: Card(
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))
                  //set border radius more than 50% of height and width to make circle
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                              child: iconcreation(
                                  Icons.camera_alt, Colors.pink, "Camera")),
                          GestureDetector(
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              child: iconcreation(
                                  Icons.insert_photo, Colors.purple, "Gallery"))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
    Widget iconcreation(IconData icon, Color color, String text) {
      return Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 30,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          getText(
              title: text,
              size: 14,
              fontFamily: celiaRegular,
              color: ColorConstant.blackColor,
              fontWeight: FontWeight.w500),
        ],
      );
    }
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      //imgUrl.value = pickedImage.path;
      imgFile.value = File(pickedImage.path);
      print(imgFile);
    } else {
      showToast("Error No image selected");
    }
  }
}
