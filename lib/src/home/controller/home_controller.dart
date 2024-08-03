import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/common/enum/market_enum.dart';
import 'package:nero_app/src/common/model/product_search_option.dart';

import '../../common/model/product.dart';
import '../../product/repository/product_repository.dart';

class HomeController extends GetxController {
  ProductRepository _productRepository;
  HomeController(this._productRepository);
  RxList<Product> productList = <Product>[].obs;
  ProductSearchOption searchOption = ProductSearchOption(
    status: const [
      ProductStatusType.sale,
      ProductStatusType.reservation,
    ]
  );

  @override
  void onInit() {
    super.onInit();
    _loadProductList();
  }

  void _initData(){
    searchOption = searchOption.copyWith(lastItem: null);
    productList.clear();
  }

  void refresh() async {
   _initData();
   await _loadProductList();
  }

  Future<void> _loadProductList() async {
    var result = await _productRepository.getProducts(searchOption);
    productList.addAll(result.list);
  }
}