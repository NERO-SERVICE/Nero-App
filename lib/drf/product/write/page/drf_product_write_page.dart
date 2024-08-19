import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/product/write/controller/drf_product_write_controller.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/components/common_text_field.dart';
import 'package:nero_app/src/common/components/custom_checkbox.dart';
import 'package:nero_app/src/common/components/multiful_image_view.dart';
import 'package:nero_app/src/common/components/trade_location_map.dart';
import 'package:nero_app/src/common/model/asset_value_entity.dart';

class DrfProductWritePage extends StatefulWidget {
  @override
  _DrfProductWritePageState createState() => _DrfProductWritePageState();
}

class _DrfProductWritePageState extends State<DrfProductWritePage> {
  Widget get _divider => const Divider(
        color: Color(0xff3C3C3E),
        indent: 25,
        endIndent: 25,
      );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DrfProductWriteController());
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/svg/icons/close.svg'),
          ),
        ),
        centerTitle: true,
        title: const AppFont(
          '내 물건 팔기',
          fontWeight: FontWeight.bold,
          size: 18,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              controller.submit(context);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 20.0, right: 25),
              child: AppFont(
                '완료',
                color: Color(0xffD0EE17),
                fontWeight: FontWeight.bold,
                size: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _PhotoSelectedView(),
                  _divider,
                  _ProductTitleView(),
                  _divider,
                  _PriceSettingView(),
                  _divider,
                  _ProductDescription(),
                  Container(
                    height: 5,
                    color: Color(0xff3C3C3E),
                  ),
                  _HopeTradeLocationMap(),
                ],
              ),
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xff3C3C3E),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svg/icons/photo_small.svg'),
                    const SizedBox(width: 10),
                    GetBuilder<DrfProductWriteController>(
                      builder: (controller) {
                        return AppFont(
                          '${controller.selectedImages.length}/10',
                          size: 13,
                          color: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  behavior: HitTestBehavior.translucent,
                  child: SvgPicture.asset('assets/svg/icons/keyboard-down.svg'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _PhotoSelectedView extends GetView<DrfProductWriteController> {
  const _PhotoSelectedView({super.key});

  Widget _photoSelectIcon() {
    return GestureDetector(
      onTap: () async {
        var selectedImages = await Get.to<List<AssetValueEntity>?>(
          MultifulImageView(
            initImages: controller.selectedImages.toList(),
          ),
        );
        controller.changeSelectedImages(selectedImages);
      },
      child: Container(
        width: 77,
        height: 77,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xff42464E)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<DrfProductWriteController>(
              builder: (controller) {
                return AppFont(
                  '${controller.selectedImages.length}',
                  size: 13,
                  color: const Color(0xff868B95),
                );
              },
            ),
            AppFont(
              '/10',
              size: 13,
              color: Color(0xff868B95),
            )
          ],
        ),
      ),
    );
  }

  Widget _selectedImageList() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      height: 77,
      child: GetBuilder<DrfProductWriteController>(
        builder: (controller) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 20),
                    child: FutureBuilder(
                      future: controller.selectedImages[index].file,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.file(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        controller.deleteImage(index);
                      },
                      child: SvgPicture.asset('assets/svg/icons/remove.svg'),
                    ),
                  )
                ],
              );
            },
            itemCount: controller.selectedImages.length,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Row(
        children: [
          _photoSelectIcon(),
          Expanded(child: _selectedImageList()),
        ],
      ),
    );
  }
}

class _ProductTitleView extends GetView<DrfProductWriteController> {
  const _ProductTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GetBuilder<DrfProductWriteController>(
        builder: (controller) {
          return CommonTextField(
            hintText: '글 제목',
            initText: controller.product.value.title,
            onChange: controller.changeTitle,
            hintColor: const Color(0xff6D7179),
          );
        },
      ),
    );
  }
}

class _PriceSettingView extends GetView<DrfProductWriteController> {
  const _PriceSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: Obx(
                  () => CommonTextField(
                hintColor: const Color(0xff6D7179),
                hintText: '가격 (선택 사항)',
                textInputType: TextInputType.number,
                initText: controller.product.value.productPrice.toString(),
                onChange: controller.changePrice,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$'))
                ],
              ),
            ),
          ),
          Obx(
                () => CustomCheckbox(
              label: '나눔',
              isChecked: controller.product.value.isFree,
              toggleCallBack: controller.changeIsFreeProduct,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDescription extends GetView<DrfProductWriteController> {
  const _ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GetBuilder<DrfProductWriteController>(
        builder: (controller) {
          return CommonTextField(
            hintColor: Color(0xff6D7179),
            hintText: '게시글을 작성해주세요\n(규정을 준수하지 않은 게시물은 삭제될 수 있습니다)',
            textInputType: TextInputType.multiline,
            maxLines: 10,
            initText: controller.product.value.description,
            onChange: controller.changeDescription,
          );
        },
      ),
    );
  }
}

class _HopeTradeLocationMap extends GetView<DrfProductWriteController> {
  const _HopeTradeLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          var result = await Get.to<Map<String, dynamic>?>(
            TradeLocationMap(
              lable: controller.product.value.wantTradeLocationLabel,
              location: controller.product.value.wantTradeLocation?.first,
            ),
          );
          if (result != null) {
            controller.changeTradeLocationMap(result);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppFont(
              '모임 희망 장소',
              size: 16,
              color: Colors.white,
            ),
            GetBuilder<DrfProductWriteController>(
              builder: (controller) {
                return controller.product.value.wantTradeLocationLabel ==
                            null ||
                        controller.product.value.wantTradeLocationLabel!.isEmpty
                    ? Row(
                        children: [
                          const AppFont(
                            '장소 선택',
                            size: 13,
                            color: Color(0xff6D7179),
                          ),
                          SvgPicture.asset('assets/svg/icons/right.svg'),
                        ],
                      )
                    : Row(
                        children: [
                          AppFont(
                            controller.product.value.wantTradeLocationLabel ??
                                '',
                            size: 13,
                            color: Colors.white,
                          ),
                          GestureDetector(
                            onTap: () => controller.clearWantTradeLocation(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                  'assets/svg/icons/delete.svg'),
                            ),
                          )
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
