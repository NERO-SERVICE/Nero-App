import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../common/enum/market_enum.dart';
import '../../../common/model/product.dart';
import '../../../user/model/user_model.dart';
import '../../repository/product_repository.dart';

class ProductWriteController extends GetxController {
  final UserModel owner;
  final Rx<Product> product = const Product().obs;
  final ProductRepository _productRepository;
  RxList<AssetEntity> selectedImages = <AssetEntity>[].obs;

  ProductWriteController(this.owner, this._productRepository);

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
