import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/product/controller/drf_product_controller.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';
import 'package:nero_app/src/common/model/asset_value_entity.dart';

class DrfProductWriteController extends GetxController {
  DrfProductController _drfProductService = DrfProductController();
  final Rx<DrfProduct> product = DrfProduct(
    owner: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    wantTradeLocation: {},
  ).obs;

  RxList<AssetValueEntity> selectedImages = <AssetValueEntity>[].obs;

  // 이미지 선택
  void changeSelectedImages(List<AssetValueEntity>? images) {
    if (images != null) {
      selectedImages.assignAll(images.map((asset) => AssetValueEntity(asset: asset)).toList());
    }
  }

  // 이미지 삭제
  void deleteImage(int index) {
    selectedImages.removeAt(index);
  }

  // 제품 제목 변경
  void changeTitle(String value) {
    product.value = product.value.copyWith(title: value);
  }

  // 카테고리 타입 변경
  void changeCategoryType(String? type) {
    if (type != null) {
      product.value = product.value.copyWith(categoryType: type);
    }
  }

  // 가격 변경
  void changePrice(String price) {
    if (RegExp(r'^[0-9]+$').hasMatch(price)) {
      product.value = product.value.copyWith(
        productPrice: int.parse(price),
        isFree: int.parse(price) == 0,
      );
    }
  }

  // 나눔 여부 변경
  void changeIsFreeProduct() {
    product.value = product.value.copyWith(
      isFree: !(product.value.isFree ?? false),
      productPrice: product.value.isFree ? 0 : product.value.productPrice,
    );
  }

  // 설명 변경
  void changeDescription(String value) {
    product.value = product.value.copyWith(description: value);
  }

  // 거래 위치 변경
  void changeTradeLocationMap(Map<String, dynamic> mapInfo) {
    product.value = product.value.copyWith(
      wantTradeLocationLabel: mapInfo['label'],
      wantTradeLocation: mapInfo['location'] as Map<String, double>,
    );
  }

  // 거래 위치 초기화
  void clearWantTradeLocation() {
    product.value = product.value.copyWith(
      wantTradeLocationLabel: '',
      wantTradeLocation: null,
    );
  }


  // 폼 제출
  Future<void> submit(BuildContext context) async  {
    try {
      List<File> imageFiles = [];
      for (var asset in selectedImages) {
        final file = await asset.file;
        print('Selected file: ${file?.path}');
        if (file != null) {
          imageFiles.add(file);
        }
      }

      final result = await _drfProductService.createProduct(product.value, imageFiles);
      if (result != null) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product created successfully!'),
          ),
        );
      } else {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      print("Error submitting product: $e");
      // 에러 시 실패 메시지를 띄움
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create product: $e'),
        ),
      );
    }
  }
}
