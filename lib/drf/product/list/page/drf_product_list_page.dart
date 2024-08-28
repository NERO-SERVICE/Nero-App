import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/drf/product/controller/drf_product_controller.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';
import 'package:nero_app/drf/product/write/page/drf_product_write_page.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';

class DrfProductListPage extends StatefulWidget {
  @override
  _DrfProductListPageState createState() => _DrfProductListPageState();
}

class _DrfProductListPageState extends State<DrfProductListPage> {
  final DrfProductController _productService = DrfProductController();
  List<DrfProduct> _products = [];
  final PageController _pageController = PageController(viewportFraction: 0.7);

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
          color: Color(0xff878B93),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 300,
              height: 400,
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
          const SizedBox(height: 10),
          AppFont(
            product.title ?? '',
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(height: 5),
          subInfo(product),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return FractionallySizedBox(
              widthFactor: 1.0,
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 25.0 : 10.0,
                  right: index == _products.length - 1 ? 25.0 : 10.0,
                ),
                child: _productOne(_products[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              Get.to(() => DrfProductWritePage());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
