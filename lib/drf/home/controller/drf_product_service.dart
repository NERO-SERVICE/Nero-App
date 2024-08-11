import 'package:flutter/material.dart';
import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';

class DrfProductService {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  // product 리스트 불러오기
  Future<List<DrfProduct>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      print(response.data);

      List<DrfProduct> products = response.data
          .map<DrfProduct>((item) => DrfProduct.fromJson(item))
          .toList();
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

  // Product 생성하기
  Future<DrfProduct?> createProduct(DrfProduct product) async {
    try {
      // DrfProduct 객체를 JSON 형식으로 변환
      final data = product.toJson();
      print('Request Data: $data');  // 전송 데이터 확인

      // POST 요청을 통해 데이터를 서버로 전송
      final response = await _dio.post('/products/create/', data: data);

      // 서버에서 201 상태 코드(성공적으로 생성됨)를 반환한 경우
      if (response.statusCode == 201) {
        // 응답 데이터를 DrfProduct 객체로 변환하여 반환
        return DrfProduct.fromJson(response.data);
      } else {
        // 그렇지 않으면 null 반환
        return null;
      }
    } catch (e) {
      print('Failed to create product: $e');
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
      final response =
          await _dio.delete('/products/$id/delete/', data: {'id': id});
      return response.statusCode == 204;
    } catch (e) {
      print('Failed to delete product: $e');
      return false;
    }
  }
}
