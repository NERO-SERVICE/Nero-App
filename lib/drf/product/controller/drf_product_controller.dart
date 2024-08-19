import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';

class DrfProductController {
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

  // Product 생성하기 (이미지 업로드 포함)
  Future<DrfProduct?> createProduct(DrfProduct product, List<File> imageFiles) async {
    try {
      // Multipart request를 위한 FormData 객체 생성
      FormData formData = FormData.fromMap({
        ...product.toJson(),  // 기존 product 데이터를 JSON으로 변환 후 추가
        'imageFiles': [
          for (var file in imageFiles)
            await MultipartFile.fromFile(file.path)
        ],
      });

      // 서버로 전송할 데이터를 출력
      print('FormData to be sent:');
      formData.fields.forEach((field) {
        print('Field: ${field.key}: ${field.value}');
      });
      formData.files.forEach((file) {
        print('File: ${file.key}: ${file.value.filename}');
      });

      // POST 요청을 통해 데이터를 서버로 전송
      final response = await _dio.postFormData('/products/create/', formData: formData);

      // 서버에서 201 상태 코드(성공적으로 생성됨)를 반환한 경우
      if (response.statusCode == 201) {
        return DrfProduct.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to create product: $e');
      return null;
    }
  }

  // Product 수정하기 (이미지 업로드 포함)
  Future<bool> updateProduct(DrfProduct product, List<File>? imageFiles) async {
    try {
      // Multipart request를 위한 FormData 객체 생성
      FormData formData = FormData.fromMap({
        ...product.toJson(),  // 기존 product 데이터를 JSON으로 변환 후 추가
        if (imageFiles != null)
          'imageFiles': [
            for (var file in imageFiles)
              await MultipartFile.fromFile(file.path)
          ],
      });

      // PUT 요청을 통해 데이터를 서버로 전송
      final response = await _dio.putFormData('/products/${product.id}/update/', formData: formData);

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
