import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../ScreenRoutes/routes.dart';
import '../../helper/appimage.dart';
import '../../helper/custombtn_new.dart';
import '../../helper/getText.dart';
import '../../utils/color_constant.dart';
import '../../utils/stringConstants.dart';
import '../../utils/screensize.dart';
import '../../utils/toast.dart';
import '../../utils/validation.dart';
import '../../widget/customTextField.dart';
import 'controller/loginController.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends GetWidget<LoginController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        /* appBar: appBar(context, "", () {
          SystemNavigator.pop();
        }),*/
        body: SingleChildScrollView(
          child: Form(
            // key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height / 2.2,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      fit: BoxFit.fitWidth,
                      AppImages.loginBack,
                    )),
                ScreenSize.height(35),
                getText(
                    title: userLoginTitle,
                    textAlign: TextAlign.start,
                    size: 25,
                    letterSpacing: 1,
                    fontFamily: interBold,
                    color: ColorConstant.blackColor,
                    fontWeight: FontWeight.w500),
                ScreenSize.height(10),
                getText(
                    title: expertLoginSubTitle,
                    textAlign: TextAlign.start,
                    size: 11,
                    fontFamily: interMedium,
                    color: ColorConstant.loginSubTitle,
                    fontWeight: FontWeight.w500),
                ScreenSize.height(25),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomTextField(
                          hintText: "",
                          labelText: loginMobile,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                             LengthLimitingTextInputFormatter(10),
                          ],
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          auto: AutovalidateMode.onUserInteraction,
                          controller: controller.mobileController,
                          validator: (value) {
                            if (value == null ||
                                value.length != 10 ||
                                (!isValidPhone(value, isRequired: true))) {
                              return loginMobileValidation;
                            }
                            return null;
                          },
                        ),
                      ),
                      ScreenSize.height(10),
                      Obx(
                        () => CustomBtnNew(
                            title: loginButton,
                            height: 50,
                            width: double.infinity,
                            rectangleBorder: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.transparent, width: 1.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: ColorConstant.onBoardingBack,
                            isLoading: controller.isLoading.value,
                            onTap: () {
                              controller.selectButton1();
                              if (controller.mobileController.text.isEmpty ||
                                  controller.mobileController.text == "") {
                                showToast(loginMobileToast);
                              } else {
                                controller.loginApiFunction(context);
                              }
                            },
                            textColor: ColorConstant.whiteColor),
                      ),
                      ScreenSize.height(10),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const getText(
                                  title: createAccount,
                                  size: 12,
                                  fontFamily: interRegular,
                                  color: ColorConstant.lightGray,
                                  fontWeight: FontWeight.w500),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  controller.selectButton2();
                                  controller.resetValues();
                                  Get.toNamed(AppRoutes.selectCreateAccount);
                                },
                                child: const getText(
                                    title: signUp,
                                    size: 12,
                                    fontFamily: interRegular,
                                    color: ColorConstant.onBoardingBack,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ScreenSize.height(15),
                      Image.asset(AppImages.or),
                      ScreenSize.height(15),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: ()async{
                              User? user = await controller.authService.signInWithGoogle();
                              if (user != null) {
                                  controller.user = user;
                                  controller.socialLoginApiFunction(context);
                              }
                            },
                              child: Image.asset(AppImages.google,scale: 12,)),
                        ],
                      ),
                      ScreenSize.height(15),
                    ],
                  ),
                ),
                ScreenSize.height(25),
                const getText(
                    title: termsText1,
                    textAlign: TextAlign.center,
                    size: 15,
                    fontFamily: interRegular,
                    color: ColorConstant.lightGray,
                    fontWeight: FontWeight.w400),
                ScreenSize.height(5),
                InkWell(
                  onTap: (){
                    Get.toNamed(AppRoutes.helpSupportScreen,arguments: ['termsConditions',""]);
                  },
                  child: Text(
                    loginTerms,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: interRegular,
                        fontSize: 12,
                        color: ColorConstant.lightGray,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                ScreenSize.height(15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
