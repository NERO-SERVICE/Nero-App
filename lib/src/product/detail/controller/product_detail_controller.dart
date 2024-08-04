import 'package:get/get.dart';
import 'package:nero_app/src/common/model/product.dart';
import 'package:nero_app/src/product/repository/product_repository.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepository;

  ProductDetailController(this._productRepository);

  late String docId;
  Rx<Product> product = const Product.empty().obs;

  @override
  void onInit() async {
    super.onInit();
    docId = Get.parameters['docId'] ?? '';
    await _loadProductDetailData();
  }

  Future<void> _loadProductDetailData() async {
    var result = await _productRepository.getProduct(docId);
    if (result == null) return;
    product(result);
  }
}
