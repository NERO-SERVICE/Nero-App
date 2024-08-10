import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';

class DrfProductService {
  final DioService _dio = DioService();

  Future<List<DrfProduct>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      print(response.data);

      List<DrfProduct> products = response.data.map<DrfProduct>((item) => DrfProduct.fromJson(item)).toList();
      return products;
    } catch (e) {
      print('Failed to load products: $e');
      rethrow;
    }
  }
}
