import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/home/controller/drf_product_service.dart';
import 'package:nero_app/drf/home/page/drf_home_detail_page.dart';
import 'package:nero_app/drf/home/page/drf_home_write_page.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';

class DrfProductListPage extends StatefulWidget {
  @override
  _DrfProductListPageState createState() => _DrfProductListPageState();
}

class _DrfProductListPageState extends State<DrfProductListPage> {
  final DrfProductService _productService = DrfProductService();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: _products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.description ?? 'No description'),
                  onTap: () {
                    // Product 상세 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DrfProductDetailPage(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => DrfHomeWritePage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
