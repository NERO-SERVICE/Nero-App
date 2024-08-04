import 'package:get/get.dart';
import 'package:nero_app/src/common/enum/market_enum.dart';
import 'package:nero_app/src/common/model/product.dart';
import 'package:nero_app/src/common/model/product_search_option.dart';
import 'package:nero_app/src/product/repository/product_repository.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepository;

  ProductDetailController(this._productRepository);

  late String docId;
  Rx<Product> product = const Product.empty().obs;
  RxList<Product> ownerOtherProducts = <Product>[].obs;

  @override
  void onInit() async {
    super.onInit();
    docId = Get.parameters['docId'] ?? '';
    await _loadProductDetailData();
    await _loadOtherProducts();
  }

  Future<void> _loadProductDetailData() async {
    var result = await _productRepository.getProduct(docId);
    if (result == null) return;
    product(result);
  }

  Future<void> _loadOtherProducts() async {
    var searchOption = ProductSearchOption(
        ownerId: product.value.owner?.uid ?? '',
        status: const [
          ProductStatusType.sale,
          ProductStatusType.reservation,
        ]
    );

    var results = await _productRepository.getProducts(searchOption);
    ownerOtherProducts.addAll(results.list);
  }
}
