import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/filter/filter_controller.dart';
import 'package:senoritaApp/UserApp/BottomMenuScreen/single_category_list_screen/controller/single_category_list_controller.dart';
import 'package:senoritaApp/helper/appbar.dart';
import 'package:senoritaApp/helper/custombtn.dart';
import 'package:senoritaApp/helper/getText.dart';
import 'package:senoritaApp/utils/color_constant.dart';
import 'package:senoritaApp/utils/screensize.dart';
import 'package:senoritaApp/utils/stringConstants.dart';
import 'package:senoritaApp/widget/checkbox_widget.dart';
import 'package:senoritaApp/widget/rating_widget.dart';

class FilterScreen extends GetView<FilterController> {
  final SingleCategoryListController controllerCat = Get.put(SingleCategoryListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        "Filter",
        () {
          Get.back();
        },
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [leftSideBarWidget(), Expanded(child: rightSideBarWidget())],
      ),
      bottomNavigationBar: Container(
        height: 120,
        decoration: BoxDecoration(color: ColorConstant.white, boxShadow: [
          BoxShadow(offset: const Offset(0, -2), color: ColorConstant.blackColor.withOpacity(.1), blurRadius: 10)
        ]),
        padding: const EdgeInsets.only(left: 21, right: 22, top: 10, bottom: 6),
        child: Column(
          children: [
            CustomBtn(
                title: 'Apply',
                height: 50,
                width: double.infinity,
                onTap: () {
                  callBack();
                },
                color: ColorConstant.appColor),
            ScreenSize.height(6),
            InkWell(
              onTap: () {
                if (controller.route.value == 'offer' || controller.selectedCategoryIdBySingleScreen.isEmpty) {
                  controller.mergeCategoryModel.value.selectedCategory.clear();
                  for (int i = 0; i < controller.mergeCategoryModel.value.data!.length; i++) {
                    controller.mergeCategoryModel.value.data![i].isSelectedCat.value = false;
                    for (int j = 0; j < controller.mergeCategoryModel.value.data![i].baseCategoryArray!.length; j++) {
                      controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].isSelectedSubCat.value = false;
                      controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].selectedSubCategory.clear();
                    }
                  }
                } else {
                  controller.subCatModel.value.selectedList.clear();
                  for (int i = 0; i < controller.subCatModel.value.data!.length; i++) {
                    controller.subCatModel.value.data![i].isSelected.value = false;
                  }
                }
                controller.selectedPriceValue.value = '';
                controller.selectedSort.value = 10;
                controller.selectedDiscountValue.value = '';
                controller.selectedRating.value = 0.0;
                controller.currentRangeValues.value = 0.0;
                controllerCat.savedFilterValues.clear();
                callBack();

                Fluttertoast.showToast(msg: "Filter Reset Successfully");
                // Get.back(result: {'category':'','subcat':'','price':'','discount':'',
                //   'rating':controller.selectedRating.value,'distance':"0-0",
                //   'offer':controller.route.value=='offer'?'':'2',
                //   'topRated':'',
                //   'arrivals':''
                // },);
              },
              child: Container(
                height: 30,
                alignment: Alignment.center,
                color: ColorConstant.white,
                child: const getText(
                    title: 'Reset Filter',
                    size: 15,
                    fontFamily: interMedium,
                    color: ColorConstant.blackLight,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }

  callBack() {
    if (controller.route.value == 'offer' || controller.selectedCategoryIdBySingleScreen.isEmpty) {
      List allCatList = [];
      List<Map<String, dynamic>> result = [];
      Map<int, Map<String, dynamic>> categoryMap = {};

      for (int i = 0; i < controller.mergeCategoryModel.value.data!.length; i++) {
        for (int j = 0; j < controller.mergeCategoryModel.value.data![i].baseCategoryArray!.length; j++) {
          for (int k = 0;
              k < controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].selectedSubCategory.length;
              k++) {
            allCatList.add({
              "id": controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].selectedSubCategory[k]['id'],
              "name": controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].selectedSubCategory[k]['name'],
              "catName": controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].selectedSubCategory[k]
                  ['catName'],
              "catId": controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].selectedSubCategory[k]
                  ['catId']
            });

            print(controller.mergeCategoryModel.value.data![i].baseCategoryArray![j].selectedSubCategory[k]['id']);
          }
        }
      }
      // print(allCatList);
      for (var item in allCatList) {
        int catId = item['catId'];
        String catName = item['catName'];
        // If category is not already added, create a new entry
        if (!categoryMap.containsKey(catId)) {
          categoryMap[catId] = {"name": catName, "id": catId.toString(), "subCat": []};
        }

        categoryMap[catId]!['subCat'].add({"id": item['id'].toString(), "name": item['name']});
      }

      result = categoryMap.values.toList();

      // print(result);
      String subCatIds =
          result.expand((category) => category['subCat']).map((subCat) => subCat['id'].toString()).join(', ');
      String categoryIds = result.map((category) => category['id'].toString()).join(', ');
      Get.back(
        result: {
          'category': categoryIds,
          'subcat': subCatIds,
          'catList': result,
          'price': controller.selectedPriceValue.value.toLowerCase() == "low to high"
              ? "desc"
              : controller.selectedPriceValue.value.toLowerCase() == "high to low"
                  ? 'asc'
                  : "",
          'discount': controller.selectedDiscountValue.value,
          'rating': controller.selectedRating.value == 0.0 ? '' : controller.selectedRating.value.toInt().toString(),
          'distance': controller.currentRangeValues.value.round() >= 1
              ? controller.currentRangeValues.value.round().toString()
              : "",
          'offer': '1',
          'topRated': controller.selectedSort.value == 0 ? '5' : '',
          'arrivals': controller.selectedSort.value == 1 ? '1' : ''
        },
      );
    } else {
      String subCatId = controller.subCatModel.value.selectedList.map((e) => e).join(',');
      print(subCatId);
      Get.back(
        result: {
          'category': controller.selectedCategoryIdBySingleScreen.value,
          'subcat': subCatId,
          'price': controller.selectedPriceValue.value.toLowerCase() == "low to high"
              ? "desc"
              : controller.selectedPriceValue.value.toLowerCase() == "high to low"
                  ? 'asc'
                  : "",
          'discount': controller.selectedDiscountValue.value,
          'rating': controller.selectedRating.value == 0.0 ? '' : controller.selectedRating.value.toInt().toString(),
          'distance': controller.currentRangeValues.value.round() >= 1
              ? controller.currentRangeValues.value.round().toString()
              : "",
          'offer': controller.selectedSort.value == 0 ? '1' : '2',
          'topRated': controller.selectedSort.value == 0 ? '5' : '',
          'arrivals': controller.selectedSort.value == 1 ? '1' : ''
        },
      );
    }
  }

  leftSideBarWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          width: 120,
          color: ColorConstant.lightColor.withOpacity(.4),
        ),
        filterTypesUi('Categories', 0),
        filterTypesUi('Price', 1),
        filterTypesUi('Discount', 2),
        filterTypesUi('Rating', 3),
        filterTypesUi('Distance', 4),
        filterTypesUi('Sort By', 5),
        Container(
          height: 20,
          width: 120,
          color: ColorConstant.lightColor.withOpacity(.4),
        ),
      ],
    );
  }

  rightSideBarWidget() {
    return Obx((() => controller.selectedFilterIndex.value == 0
        ? controller.route.value == 'offer' || controller.selectedCategoryIdBySingleScreen.isEmpty
            ? categoryWidget()
            : selectedCategoryFromSingleScreenWidget()
        : controller.selectedFilterIndex.value == 1
            ? priceFilterWidget()
            : controller.selectedFilterIndex.value == 2
                ? discountFilterWidget()
                : controller.selectedFilterIndex.value == 3
                    ? ratingFilterWidget()
                    : controller.selectedFilterIndex.value == 4
                        ? distanceWidget()
                        : controller.selectedFilterIndex.value == 5
                            ? sortByFilter()
                            : Container()));
  }

  filterTypesUi(String title, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.selectedFilterIndex.value = index;
        },
        child: Container(
          padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
          width: 120,
          color: controller.selectedFilterIndex.value == index
              ? ColorConstant.white
              : ColorConstant.lightColor.withOpacity(.4),
          child: getText(
              title: title,
              size: 15,
              fontFamily: interMedium,
              color: ColorConstant.blackColor,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  selectedCategoryFromSingleScreenWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 13, right: 15, bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // headingWidget('Categories'),
          // ScreenSize.height(15),
          Row(
            children: [
              checkBoxWidget(ColorConstant.appColor, size: 20),
              ScreenSize.width(6),
              Expanded(
                child: getText(
                    title: controller.selectedCategoryNameBySingleScreen.value,
                    size: 12,
                    fontFamily: interRegular,
                    color: ColorConstant.qrViewText,
                    fontWeight: FontWeight.w400),
              ),
              ScreenSize.width(2),
              GestureDetector(
                onTap: () {
                  if (controller.isShowSubCat.value) {
                    controller.isShowSubCat.value = false;
                  } else {
                    controller.isShowSubCat.value = true;
                  }
                },
                child: Icon(
                  controller.isShowSubCat.value ? Icons.minimize : Icons.add,
                  color: controller.isShowSubCat.value ? ColorConstant.appColor : ColorConstant.qrViewText,
                  size: 17,
                ),
              )
            ],
          ),
          controller.subCatModel != null &&
                  controller.subCatModel.value.data != null &&
                  controller.isShowSubCat.value == true
              ? ListView.separated(
                  separatorBuilder: (context, sp1) {
                    return ScreenSize.height(11);
                  },
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 11, left: 25),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.subCatModel.value.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (controller.subCatModel.value.data![index].isSelected.value) {
                          controller.subCatModel.value.data![index].isSelected.value = false;
                          for (int i = 0; i < controller.subCatModel.value.selectedList.length; i++) {
                            if (controller.subCatModel.value.selectedList[i] ==
                                controller.subCatModel.value.data![index].id.toString()) {
                              controller.subCatModel.value.selectedList.removeAt(i);
                            }
                          }
                        } else {
                          controller.subCatModel.value.data![index].isSelected.value = true;
                          controller.subCatModel.value.selectedList
                              .add(controller.subCatModel.value.data![index].id.toString());
                        }
                      },
                      child: Row(
                        children: [
                          Obx(
                            () => checkBoxWidget(
                                controller.subCatModel.value.data![index].isSelected.value
                                    ? ColorConstant.appColor
                                    : ColorConstant.white,
                                size: 18,
                                borderColor: controller.subCatModel.value.data![index].isSelected.value
                                    ? ColorConstant.appColor
                                    : ColorConstant.blackLight),
                          ),
                          ScreenSize.width(6),
                          Expanded(
                            child: getText(
                                title: controller.subCatModel.value.data![index].name,
                                size: 11,
                                fontFamily: interRegular,
                                color: ColorConstant.qrViewText,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    );
                  })
              : Container()
        ],
      ),
    );
  }

  categoryWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 13, right: 15, bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // headingWidget('Categories'),
          // ScreenSize.height(15),
          controller.mergeCategoryModel != null && controller.mergeCategoryModel.value.data != null
              ? ListView.separated(
                  separatorBuilder: (context, sp) {
                    return ScreenSize.height(18);
                  },
                  itemCount: controller.mergeCategoryModel.value.data!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Obx(
                      () => Column(
                        children: [
                          InkWell(
                            onTap: () {
                              print(controller.mergeCategoryModel.value.data![index].baseCategoryArray);
                              if (controller.mergeCategoryModel.value.data![index].isSelectedCat.value) {
                                print('object');

                                /// default value
                                ///  unselected subcat
                                for (int i = 0;
                                    i < controller.mergeCategoryModel.value.data![index].baseCategoryArray!.length;
                                    i++) {
                                  controller.mergeCategoryModel.value.data![index].baseCategoryArray![i]
                                      .isSelectedSubCat.value = false;
                                  controller
                                      .mergeCategoryModel.value.data![index].baseCategoryArray![i].selectedSubCategory
                                      .clear();
                                }
                                for (int i = 0;
                                    i < controller.mergeCategoryModel.value.selectedCategory.value.length;
                                    i++) {
                                  print(controller.mergeCategoryModel.value.selectedCategory[i]);
                                  if (controller.mergeCategoryModel.value.selectedCategory.value[i]['id'].toString() ==
                                      controller.mergeCategoryModel.value.data![index].id.toString()) {
                                    controller.mergeCategoryModel.value.selectedCategory.removeAt(i);
                                  }
                                }
                                controller.mergeCategoryModel.value.data![index].isSelectedCat.value = false;
                                controller.mergeCategoryModel.value.isOpenSubCategory.value = 1000;
                              } else {
                                controller.mergeCategoryModel.value.data![index].isSelectedCat.value = true;
                                controller.mergeCategoryModel.value.isOpenSubCategory.value = index;
                                controller.mergeCategoryModel.value.selectedCategory.value.add({
                                  "name": controller.mergeCategoryModel.value.data![index].name.toString(),
                                  "id": controller.mergeCategoryModel.value.data![index].id.toString()
                                });

                                if (controller.mergeCategoryModel != null &&
                                    controller.mergeCategoryModel.value.data != null &&
                                    controller.mergeCategoryModel.value.data![index].baseCategoryArray != null &&
                                    controller.mergeCategoryModel.value.isOpenSubCategory.value == index) {
                                  for (int i = 0;
                                      i < controller.mergeCategoryModel.value.data![index].baseCategoryArray!.length;
                                      i++) {
                                    controller.mergeCategoryModel.value.data![index].baseCategoryArray![i]
                                        .isSelectedSubCat.value = true;
                                    controller
                                        .mergeCategoryModel.value.data![index].baseCategoryArray![i].selectedSubCategory
                                        .add({
                                      'id': controller.mergeCategoryModel.value.data![index].baseCategoryArray![i].id
                                          .toString(),
                                      'name': controller
                                          .mergeCategoryModel.value.data![index].baseCategoryArray![i].name
                                          .toString(),
                                      "catName": controller.mergeCategoryModel.value.data![index].name,
                                      'catId': controller.mergeCategoryModel.value.data![index].id
                                    });
                                  }
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Obx(() => checkBoxWidget(
                                    controller.mergeCategoryModel.value.data![index].isSelectedCat.value
                                        ? ColorConstant.appColor
                                        : ColorConstant.white,
                                    size: 20,
                                    borderColor: controller.mergeCategoryModel.value.data![index].isSelectedCat.value
                                        ? ColorConstant.appColor
                                        : ColorConstant.blackLight)),
                                ScreenSize.width(6),
                                Expanded(
                                  child: getText(
                                      title: controller.mergeCategoryModel.value.data![index].name,
                                      size: 12,
                                      fontFamily: interRegular,
                                      color: ColorConstant.qrViewText,
                                      fontWeight: FontWeight.w400),
                                ),
                                ScreenSize.width(2),
                                InkWell(
                                  onTap: () {
                                    if (controller.mergeCategoryModel.value.isOpenSubCategory.value == index) {
                                      controller.mergeCategoryModel.value.isOpenSubCategory.value = 1000;

                                      ///defualt value
                                    } else {
                                      controller.mergeCategoryModel.value.isOpenSubCategory.value = index;
                                    }
                                  },
                                  child: Icon(
                                    controller.mergeCategoryModel.value.isOpenSubCategory.value == index
                                        ? Icons.minimize
                                        : Icons.add,
                                    color: controller.mergeCategoryModel.value.isOpenSubCategory.value == index
                                        ? ColorConstant.appColor
                                        : ColorConstant.qrViewText,
                                    size: 17,
                                  ),
                                )
                              ],
                            ),
                          ),
                          controller.mergeCategoryModel != null &&
                                  controller.mergeCategoryModel.value.data != null &&
                                  controller.mergeCategoryModel.value.data![index].baseCategoryArray != null &&
                                  controller.mergeCategoryModel.value.isOpenSubCategory.value == index
                              ? ListView.separated(
                                  separatorBuilder: (context, sp1) {
                                    return ScreenSize.height(11);
                                  },
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 11, left: 25),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.mergeCategoryModel.value.data![index].baseCategoryArray!.length,
                                  itemBuilder: (context, sbIndex) {
                                    return InkWell(
                                      onTap: () {
                                        if (controller.mergeCategoryModel.value.data![index].baseCategoryArray![sbIndex]
                                            .isSelectedSubCat.value) {
                                          controller.mergeCategoryModel.value.data![index].baseCategoryArray![sbIndex]
                                              .isSelectedSubCat.value = false;
                                          for (int i = 0;
                                              i <
                                                  controller.mergeCategoryModel.value.data![index]
                                                      .baseCategoryArray![sbIndex].selectedSubCategory.length;
                                              i++) {
                                            if (controller.mergeCategoryModel.value.data![index]
                                                    .baseCategoryArray![sbIndex].selectedSubCategory[i]['id'] ==
                                                controller.mergeCategoryModel.value.data![index]
                                                    .baseCategoryArray![sbIndex].id
                                                    .toString()) {
                                              controller.mergeCategoryModel.value.data![index]
                                                  .baseCategoryArray![sbIndex].selectedSubCategory
                                                  .removeAt(i);

                                              // Loop through all subcategories to check if any are selected
                                              bool hasSelectedSubCat = false;
                                              for (int i = 0;
                                                  i <
                                                      controller.mergeCategoryModel.value.data![index]
                                                          .baseCategoryArray!.length;
                                                  i++) {
                                                // Check if the subcategory is selected
                                                if (controller.mergeCategoryModel.value.data![index]
                                                        .baseCategoryArray![i].isSelectedSubCat.value ==
                                                    true) {
                                                  hasSelectedSubCat = true;
                                                } else {}
                                              }
                                              if (hasSelectedSubCat) {
                                                controller.mergeCategoryModel.value.data![index].isSelectedCat.value =
                                                    true;
                                              } else {
                                                controller.mergeCategoryModel.value.data![index].isSelectedCat.value =
                                                    false;
                                              }
                                            }
                                          }
                                        } else {
                                          for (int i = 0;
                                              i <
                                                  controller
                                                      .mergeCategoryModel.value.data![index].baseCategoryArray!.length;
                                              i++) {
                                            if (controller.mergeCategoryModel.value.data![index].baseCategoryArray![i]
                                                    .isSelectedSubCat ==
                                                true) {
                                              print('dsgfdf');
                                              break;
                                            } else {
                                              print('dfgfd');
                                              controller.mergeCategoryModel.value.selectedCategory.add({
                                                "name":
                                                    controller.mergeCategoryModel.value.data![index].name.toString(),
                                                "id": controller.mergeCategoryModel.value.data![index].id.toString()
                                              });
                                              controller.mergeCategoryModel.value.data![index].isSelectedCat.value =
                                                  true;
                                              break;
                                            }
                                          }
                                          controller.mergeCategoryModel.value.data![index].baseCategoryArray![sbIndex]
                                              .isSelectedSubCat.value = true;
                                          controller.mergeCategoryModel.value.data![index].baseCategoryArray![sbIndex]
                                              .selectedSubCategory
                                              .add({
                                            'id': controller
                                                .mergeCategoryModel.value.data![index].baseCategoryArray![sbIndex].id
                                                .toString(),
                                            'name': controller
                                                .mergeCategoryModel.value.data![index].baseCategoryArray![sbIndex].name
                                                .toString(),
                                            "catName": controller.mergeCategoryModel.value.data![index].name,
                                            'catId': controller.mergeCategoryModel.value.data![index].id
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => checkBoxWidget(
                                                controller.mergeCategoryModel.value.data![index]
                                                        .baseCategoryArray![sbIndex].isSelectedSubCat.value
                                                    ? ColorConstant.appColor
                                                    : ColorConstant.white,
                                                size: 18,
                                                borderColor: controller.mergeCategoryModel.value.data![index]
                                                        .baseCategoryArray![sbIndex].isSelectedSubCat.value
                                                    ? ColorConstant.appColor
                                                    : ColorConstant.blackLight),
                                          ),
                                          ScreenSize.width(6),
                                          Expanded(
                                            child: getText(
                                                title: controller.mergeCategoryModel.value.data![index]
                                                    .baseCategoryArray![sbIndex].name,
                                                size: 11,
                                                fontFamily: interRegular,
                                                color: ColorConstant.qrViewText,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                              : Container()
                        ],
                      ),
                    );
                  })
              : Container(),
        ],
      ),
    );
  }

  priceFilterWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            separatorBuilder: (context, sp) {
              return ScreenSize.height(14);
            },
            itemCount: controller.priceList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (controller.selectedPriceValue.value == controller.priceList[index]) {
                    controller.selectedPriceValue.value = '';
                  } else {
                    controller.selectedPriceValue.value = controller.priceList[index];
                  }
                },
                child: Obx(
                  () => Container(
                    height: 40,
                    color: controller.selectedPriceValue.value == controller.priceList[index]
                        ? const Color(0xffFFF7F9)
                        : ColorConstant.whiteColor,
                    child: Row(
                      children: [
                        customRadioButton(
                            color: controller.selectedPriceValue.value == controller.priceList[index]
                                ? ColorConstant.appColor
                                : ColorConstant.dot,
                            isIcon: controller.selectedPriceValue.value == controller.priceList[index] ? true : false),
                        ScreenSize.width(10),
                        getText(
                            title: "Price - ${controller.priceList[index]}",
                            size: 13,
                            fontFamily: interMedium,
                            color: ColorConstant.blackColor,
                            fontWeight: FontWeight.w400)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  discountFilterWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            separatorBuilder: (context, sp) {
              return ScreenSize.height(10);
            },
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.discountList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (controller.selectedDiscountValue.value == controller.discountList[index]) {
                    controller.selectedDiscountValue.value = '';
                  } else {
                    controller.selectedDiscountValue.value = controller.discountList[index];
                  }
                },
                child: Obx(
                  () => Container(
                    height: 40,
                    color: controller.selectedDiscountValue.value == controller.discountList[index]
                        ? const Color(0xffFFF7F9)
                        : ColorConstant.whiteColor,
                    child: Row(
                      children: [
                        customRadioButton(
                            color: controller.selectedDiscountValue.value == controller.discountList[index]
                                ? ColorConstant.appColor
                                : ColorConstant.dot,
                            isIcon: controller.selectedDiscountValue.value == controller.discountList[index]
                                ? true
                                : false),
                        ScreenSize.width(10),
                        getText(
                            title:
                                "${controller.discountList[index]}${controller.discountList.length - 1 == index ? '' : "% Off"}",
                            size: 13,
                            fontFamily: interMedium,
                            color: ColorConstant.blackColor,
                            fontWeight: FontWeight.w400)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ratingFilterWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingWidget('Rating'),
          ScreenSize.height(13),
          Row(
            children: [
              ratingWidget(
                  size: 20,
                  initalRating: controller.selectedRating.value,
                  isGesture: false,
                  onRatingUpdate: (val) {
                    controller.selectedRating.value = val;
                  }),
              ScreenSize.width(6),
              getText(
                  title: "${controller.selectedRating.value.toString()} +",
                  size: 13,
                  fontFamily: interMedium,
                  color: ColorConstant.blackColor,
                  fontWeight: FontWeight.w500)
            ],
          ),
        ],
      ),
    );
  }

  distanceWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingWidget("Distance"),
              headingWidget(
                  "${controller.currentRangeValues.value == 0.0 && !controller.isChangeDistanceValue.value ? "30" : controller.currentRangeValues.value.round().toString()} Km"),
            ],
          ),
          ScreenSize.height(20),
          SliderTheme(
            data: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
            child: Slider(
                activeColor: ColorConstant.appColor,
                max: 100,
                min: 0,
                inactiveColor: ColorConstant.appColor.withOpacity(.5),
                value: controller.currentRangeValues.value == 0.0 && !controller.isChangeDistanceValue.value
                    ? 30.0
                    : controller.currentRangeValues.value,
                onChanged: (val) {
                  controller.isChangeDistanceValue.value = true;
                  controller.currentRangeValues.value = val;
                }),
          )
        ],
      ),
    );
  }

  sortByFilter() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 22, left: 13, right: 15),
        separatorBuilder: (context, sp) {
          return ScreenSize.height(10);
        },
        itemCount: controller.offerSortByList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Obx(
            () => Container(
              height: 36,
              width: double.infinity,
              alignment: Alignment.center,
              color: controller.selectedSort.value == index ? const Color(0xffFFF7F9) : ColorConstant.whiteColor,
              child: InkWell(
                onTap: () {
                  if (controller.selectedSort.value == index) {
                    controller.selectedSort.value = -1;
                  } else {
                    controller.selectedSort.value = index;
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    customRadioButton(
                        color: controller.selectedSort.value == index ? ColorConstant.appColor : ColorConstant.dot,
                        isIcon: controller.selectedSort.value == index ? true : false),
                    ScreenSize.width(10),
                    getText(
                        title: controller.offerSortByList[index],
                        size: 14,
                        fontFamily: interMedium,
                        color: ColorConstant.black3333,
                        fontWeight: FontWeight.w400),
                  ],
                ),
              ),
            ),
          );
        });
  }

  headingWidget(String title) {
    return getText(
        title: title, size: 13, fontFamily: interMedium, color: ColorConstant.blackColor, fontWeight: FontWeight.w500);
  }

  sortByBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: ColorConstant.white,
        shape: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstant.whiteColor),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  color: ColorConstant.whiteColor),
              padding: const EdgeInsets.only(top: 27, left: 26, right: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getText(
                          title: 'Sort By',
                          size: 18,
                          fontFamily: interMedium,
                          color: ColorConstant.blackColor,
                          fontWeight: FontWeight.w600),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                          ))
                    ],
                  ),
                  ListView.separated(
                      padding: const EdgeInsets.only(top: 26, bottom: 26),
                      separatorBuilder: (context, sp) {
                        return ScreenSize.height(5);
                      },
                      itemCount: controller.route.value == 'offer'
                          ? controller.offerSortByList.length
                          : controller.sortByList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Container(
                            height: 36,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: controller.selectedSort.value == index
                                ? const Color(0xffFFF7F9)
                                : ColorConstant.whiteColor,
                            child: InkWell(
                              onTap: () {
                                controller.selectedSort.value = index;
                                Get.back();
                                callBack();
                                state(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  getText(
                                      title: controller.route.value == 'offer'
                                          ? controller.offerSortByList[index]
                                          : controller.sortByList[index],
                                      size: 14,
                                      fontFamily: interMedium,
                                      color: ColorConstant.black3333,
                                      fontWeight: FontWeight.w400),
                                  customRadioButton(
                                      color: controller.selectedSort.value == index
                                          ? ColorConstant.appColor
                                          : ColorConstant.dot,
                                      isIcon: controller.selectedSort.value == index ? true : false)
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            );
          });
        });
  }

  customRadioButton({required Color color, required bool isIcon}) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color), color: color),
      child: isIcon
          ? const Icon(
              Icons.check,
              color: ColorConstant.whiteColor,
              size: 13,
            )
          : Container(),
    );
  }
}
