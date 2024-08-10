import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';

class DrfProductService {
  final DioService _dio = DioService();

  // product 리스트 불러오기
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

  // 특정 Product 불러오기
  Future<DrfProduct?> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id/');
      return DrfProduct.fromJson(response.data);
    } catch (e) {
      print('Failed to load product: $e');
      return null;
    }
  }

  // Product 수정하기
  Future<bool> updateProduct(DrfProduct product) async {
    try {
      final response = await _dio.put(
        '/products/${product.id}/update/',
        data: product.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to edit product: $e');
      return false;
    }
  }

  // Product 삭제하기
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _dio.delete('/products/$id/delete/',
      data: {'id' : id});
      return response.statusCode == 204;
    } catch (e) {
      print('Failed to delete product: $e');
      return false;
    }
  }
}
