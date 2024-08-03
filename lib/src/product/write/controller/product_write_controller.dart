import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/controller/common_layout_controller.dart';
import 'package:nero_app/src/common/repository/cloud_firebase_repository.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../common/enum/market_enum.dart';
import '../../../common/model/product.dart';
import '../../../user/model/user_model.dart';
import '../../repository/product_repository.dart';

class ProductWriteController extends GetxController {
  final UserModel owner;
  final Rx<Product> product = const Product().obs;
  final ProductRepository _productRepository;
  final CloudFirebaseRepository _cloudFirebaseRepository;
  RxBool isPossibleSubmit = false.obs;
  RxList<AssetEntity> selectedImages = <AssetEntity>[].obs;

  ProductWriteController(
      this.owner, this._productRepository, this._cloudFirebaseRepository);

  @override
  void onInit() {
    super.onInit();
    product.stream.listen((event) {
      _isValidSumbmitPossible();
    });
  }

  _isValidSumbmitPossible() {
    if (selectedImages.isNotEmpty &&
        (product.value.productPrice ?? 0) >= 0 &&
        product.value.title != '') {
      isPossibleSubmit(true);
    } else {
      isPossibleSubmit(false);
    }
  }

  submit() async {
    CommonLayoutController.to.loading(true); // 로딩 시작
    var downloadUrls = await uploadImages(selectedImages);
    product(product.value.copyWith(imageUrls: downloadUrls));
    var saveId = _productRepository.saveProduct(product.value.toMap());
    CommonLayoutController.to.loading(false); // 로딩 종료

    if (saveId != null) {
      await showDialog(
        context: Get.context!,
        builder: (context) {
          return CupertinoAlertDialog(
            content: const AppFont(
              '물건이 등록되었습니다.',
              color: Colors.black,
              size: 16,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const AppFont(
                  '확인',
                  size: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          );
        },
      );
      Get.back(result: true);
    }
  }

  Future<List<String>> uploadImages(List<AssetEntity> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      var file = await image.file;
      if (file == null) return [];
      var downloadUrl =
          await _cloudFirebaseRepository.uploadFile(owner.uid!, file);
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  changeSelectedImages(List<AssetEntity>? images) {
    selectedImages(images);
  }

  deleteImage(int index) {
    selectedImages.removeAt(index);
  }

  changeTitle(String value) {
    product(product.value.copyWith(title: value));
  }

  changeCategoryType(ProductCategoryType? type) {
    product(product.value.copyWith(categoryType: type));
  }

  changeIsFreeProduct() {
    product(product.value.copyWith(isFree: !(product.value.isFree ?? false)));
    if (product.value.isFree!) {
      changePrice('0');
    }
  }

  changePrice(String price) {
    if (!RegExp(r'^[0-9]+$').hasMatch(price)) return;
    product(product.value.copyWith(
      productPrice: int.parse(price),
      isFree: int.parse(price) == 0,
    ));
  }

  changeDescription(String value) {
    product(product.value.copyWith(description: value));
  }

  changeTradeLocationMap(Map<String, dynamic> mapInfo) {
    product(product.value.copyWith(
      wantTradeLocationLabel: mapInfo['label'],
      wantTradeLocation: mapInfo['location'],
    ));
  }

  clearWantTradeLocation() {
    product(product.value
        .copyWith(wantTradeLocationLabel: '', wantTradeLocation: null));
  }
}
