import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/news/model/drf_news.dart';
import 'package:nero_app/drf/news/page/drf_news_list_page.dart';
import 'package:nero_app/drf/news/page/drf_webview_page.dart';
import 'package:nero_app/drf/news/repository/drf_news_repository.dart';
import 'package:nero_app/drf/product/controller/drf_product_controller.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';
import 'package:nero_app/drf/product/write/page/drf_product_write_page.dart';

class DrfProductListPage extends StatefulWidget {
  @override
  _DrfProductListPageState createState() => _DrfProductListPageState();
}

class _DrfProductListPageState extends State<DrfProductListPage> {
  final DrfProductController _productService = DrfProductController();
  List<DrfProduct> _products = [];
  final PageController _pageController = PageController(viewportFraction: 0.7);
  final DrfNewsRepository _newsRepository = DrfNewsRepository();
  late Future<List<DrfNews>> _latestNewsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _latestNewsFuture = _newsRepository.getLatestNews();
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
        Text(
          "${product.nickname}",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: Colors.white,
          ),
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
      child: Stack(
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 45,
            left: 24,
            right: 0,
            child: subInfo(product),
          ),
        ],
      ),
    );
  }

  String _shortenTitle(String title) {
    if (title.length > 25) {
      return '${title.substring(0, 25)}...(더보기)';
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 400,
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    '최신 뉴스 모음',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DrfNewsListPage()),
                      );
                    },
                    child: Text(
                      '더보기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.blueAccent, // 더보기 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<DrfNews>>(
              future: _latestNewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load news'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No news available'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // 스크롤 문제 방지를 위해 추가
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final news = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrfWebviewPage(
                                url: news.link,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 32.0),
                          child: Text(
                            _shortenTitle(news.title),
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xffD9D9D9),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
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
