import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/drf/product/controller/drf_product_controller.dart';
import 'package:nero_app/drf/product/write/page/drf_product_write_page.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';

class DrfProductListPage extends StatefulWidget {
  @override
  _DrfProductListPageState createState() => _DrfProductListPageState();
}

class _DrfProductListPageState extends State<DrfProductListPage> {
  final DrfProductController _productService = DrfProductController();
  final DrfProductController controller = DrfProductController();
  List<DrfProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  Widget subInfo(DrfProduct product) {
    return Row(
      children: [
        AppFont(
          "${product.nickname}",
          color: const Color(0xff878B93),
          size: 12,
        ),
        const AppFont(
          ' · ',
          color: const Color(0xff878B93),
          size: 12,
        ),
        AppFont(
          DateFormat('yyyy.MM.dd').format(product.createdAt),
          color: const Color(0xff878B93),
          size: 12,
        ),
      ],
    );
  }

  Widget _productOne(DrfProduct product) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed('/drf/product/detail/${product.id}');
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 100,
              height: 100,
              child: product.imageUrls.isNotEmpty
                  ? Image.network(
                      product.imageUrls.first,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/default.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                AppFont(
                  product.title ?? '',
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(height: 5),
                subInfo(product)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      body: ListView.separated(
        controller: controller.scrollController,
        padding: const EdgeInsets.only(left: 25.0, top: 20, right: 25),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return _productOne(product);
        },
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(
            color: Color(0xff3C3C3E),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => DrfProductWritePage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
