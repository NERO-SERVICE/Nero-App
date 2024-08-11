import 'package:get/get.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';
import 'package:nero_app/drf/product/repository/drf_product_repository.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';

class DrfProductDetailController extends GetxController {
  final DrfProductRepository _productRepository;
  final DrfUserModel myUser;

  DrfProductDetailController(
    this._productRepository,
    this.myUser,
  );

  late String docId;
  Rx<DrfProduct> product = DrfProduct.empty().obs;
  RxList<DrfProduct> ownerOtherProducts = <DrfProduct>[].obs;

  bool get isMine => myUser.uid == product.value.owner;
  bool isEdited = false;

  @override
  void onInit() async {
    super.onInit();
    docId = Get.parameters['id'] ?? '';
    await _loadProductDetailData();
  }

  void refresh() async {
    isEdited = true;
    await _loadProductDetailData();
  }

  void _updateProductInfo() async {
    await _productRepository.updateProduct(product.value);
  }

  Future<bool> deleteProduct() async {
    return await _productRepository.deleteProduct(product.value.id!);
  }

  Future<void> _loadProductDetailData() async {
    var result = await _productRepository.getProduct(int.parse(docId));
    if (result == null) return;
    product.value = result;
  }
}
