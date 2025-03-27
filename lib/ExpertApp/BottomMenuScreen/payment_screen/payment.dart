import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../ScreenRoutes/routes.dart';
import '../../../helper/appbar.dart';
import '../../../helper/appimage.dart';
import '../../../helper/custombtn.dart';
import '../../../helper/custombtn_new.dart';
import '../../../helper/getText.dart';
import '../../../utils/color_constant.dart';
import '../../../utils/screensize.dart';
import '../../../utils/stringConstants.dart';
import '../../../utils/toast.dart';
import '../../../utils/validation.dart';
import '../../../widget/customTextField.dart';
import 'controller/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {

  const PaymentScreen({key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context, () {
        Get.back();
      }),
      body: Obx(
        () => Form(
          key: controller.addMoneyFormKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  mainScreen(context),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomBtn(
                        title: "Proceed Payment",
                        height: 45,
                        width: double.infinity,
                        color: controller.amountController.text.isNotEmpty
                            ? ColorConstant.onBoardingBack
                            : ColorConstant.hintColor,
                        onTap: () {
                          if (controller.amountController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please Enter Some Amount",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          } else if (int.parse(
                                  controller.amountController.text) <
                              0) {
                            Fluttertoast.showToast(
                                msg: " greater than 0",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          } else {
                            controller.resetValues();
                            showGeneralDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionBuilder: (context, a1, a2, widget) {
                                  return Transform.scale(
                                    scale: 1.2,
                                    child: Opacity(
                                      opacity: a1.value,
                                      child: AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shape: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(16.0)

                                        ),
                                        content: Container(
                                          /*decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            image: DecorationImage(
                                              image: AssetImage(AppImages.successBack,),
                                              fit: BoxFit.cover,
                                            ),
                                          ),*/
                                          height: 250,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 50,),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child:  Image.asset(
                                                    height: 110,
                                                    width: 110,
                                                    AppImages.successPayment,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),



                                                Spacer(),
                                                GestureDetector(
                                                  behavior: HitTestBehavior.opaque,
                                                  onTap: ()
                                                  {
                                                     Get.toNamed(AppRoutes.walletScreen);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:  ColorConstant.successful,
                                                      borderRadius: BorderRadius.only(
                                                        bottomRight: Radius.circular(15),
                                                        bottomLeft: Radius.circular(15),)
                                                    ),
                                                    alignment: Alignment.center,
                                                    height: 55,
                                                    child:  getText(
                                                        title:"Payment Successful",
                                                        size: 15,
                                                        letterSpacing: 0.9,
                                                        fontFamily: interSemiBold,
                                                        color: ColorConstant.white,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),

                                              ]),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 200),
                                barrierDismissible: true,
                                barrierLabel: '',
                                context: context,
                                pageBuilder: (context, animation1, animation2) {
                                  return Container();
                                });
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  mainScreen(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15),
              child: getText(
                  title: textEnterAmountMoney,
                  size: 15,
                  fontFamily: interRegular,
                  color: ColorConstant.hintColor,
                  fontWeight: FontWeight.w500),
            ),
            ScreenSize.height(15),
            Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      decoration: const BoxDecoration(
                          color: ColorConstant.cardBack,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.currency_rupee_rounded,
                                  color: ColorConstant.blackColor,
                                  size: 17,
                                ),
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 15,
                            child: TextFormField(
                              controller: controller.amountController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,

                              onChanged: (text) {
                                 controller.amountController.text.length > 0
                                      ?controller.isVisible.value =true
                                      :controller.onChange.value = false;

                                 controller.amountController.text.length == 0? controller.selectedAmount.value = 0:"";
                              },
                              // readOnly: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: ColorConstant.hintColor,
                                      fontSize: 14),
                                  hintText: "Enter amount here"),
                              style: TextStyle(
                                  color: ColorConstant.blackColor,
                                  fontSize: 18.0),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return enterAmountValidation;
                                } else if (int.parse(controller
                                        .amountController.text
                                        .toString()) >
                                    0) {
                                  return enterValidAmountValidation;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.deepPurple,
                      thickness: 2,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  getText(
                      title: "Recommended",
                      size: 15,
                      fontFamily: interRegular,
                      color: ColorConstant.hintColor,
                      fontWeight: FontWeight.w500),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5, left: 15, right: 15, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.amountController.text = '50';
                        controller.selectedAmount.value = 1;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: controller.selectedAmount.value == 1
                                ? ColorConstant.onBoardingBack
                                : ColorConstant.white,
                            border: Border.all(width: 1, color: controller.selectedAmount.value == 1
                                ?  ColorConstant.onBoardingBack
                                :  Colors.black26,),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(
                            child: getText(
                                title: '₹50',
                                size: 14,
                                fontFamily: interRegular,
                                color: controller.selectedAmount.value == 1
                                    ? ColorConstant.white
                                    : ColorConstant.hintColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.amountController.text = '100';
                        controller.selectedAmount.value = 2;
                        // Get.toNamed(AppRoutes.addMoney);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: controller.selectedAmount.value == 2
                                ? ColorConstant.onBoardingBack
                                : ColorConstant.white,
                            border: Border.all(width: 1, color: controller.selectedAmount.value == 2
                            ?  ColorConstant.onBoardingBack
                              :  Colors.black26,),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(
                            child: getText(
                                title: '₹100',
                                size: 14,
                                fontFamily: interRegular,
                                color: controller.selectedAmount.value == 2
                                    ? ColorConstant.white
                                    : ColorConstant.hintColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.amountController.text = '150';
                        controller.selectedAmount.value = 3;
                        // Get.toNamed(AppRoutes.addMoney);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color:  controller.selectedAmount.value == 3
                                ? ColorConstant.onBoardingBack
                                : ColorConstant.white,
                            border: Border.all(width: 1, color: controller.selectedAmount.value == 3
                                ?  ColorConstant.onBoardingBack
                                :  Colors.black26,),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(
                            child: getText(
                                title: ' ₹150',
                                size: 14,
                                fontFamily: interRegular,
                                color: controller.selectedAmount.value == 3
                                    ?ColorConstant.white
                                    : ColorConstant.hintColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
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
            padding: const EdgeInsets.only(left: 15, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      height: 20,
                      width: 20,
                      AppImages.backIcon,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(
                        child: Image.asset(
                          height: 40,
                          width: 40,
                          AppImages.userIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getText(
                              title: "Glamour Haven",
                              size: 16,
                              fontFamily: interSemiBold,
                              letterSpacing: 0.4,
                              color: ColorConstant.blackColor,
                              fontWeight: FontWeight.w500),
                          SizedBox(
                            height: 3,
                          ),
                          getText(
                              title: "7023494966",
                              size: 12,
                              fontFamily: interLight,
                              color: ColorConstant.blackColor,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
      centerTitle: true,
    );
  }
}
