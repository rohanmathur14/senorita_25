import 'package:flutter/material.dart';

import '../utils/color_constant.dart';
import '../utils/stringConstants.dart';
import 'appimage.dart';

Widget searchBar({
  required bool readOnly,
  bool showPrefix = false,
  TextEditingController? controller,
  String hintText = 'Search by salons...',
  Function()? clearSearchTap,
  Function()? onTap,
  ValueChanged<String>? onChanged,
}) {
  final FocusNode focusNode = FocusNode();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    focusNode.requestFocus();
  });

  return Container(
    height: 49,
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorConstant.addPriceListText)),
    alignment: Alignment.center,
    child: TextFormField(
      focusNode: focusNode,
      readOnly: readOnly,
      controller: controller,
      autofocus: false,
      style: TextStyle(
          color: ColorConstant.blackColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: interRegular),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        prefixIcon: Container(
          alignment: Alignment.center,
          height: 15,
          width: 15,
          child: Image.asset(
            AppImages.search,
            height: 18,
            width: 18,
          ),
        ),
        suffixIcon: showPrefix
            ? GestureDetector(
          onTap: clearSearchTap,
          child: Container(
              alignment: Alignment.center,
              height: 15,
              width: 15,
              child: const Icon(
                Icons.clear,
                size: 20,
              )),
        )
            : Container(
          height: 0,
          width: 0,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: ColorConstant.qrViewText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: interRegular),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
      onTap: onTap,
    ),
  );
}