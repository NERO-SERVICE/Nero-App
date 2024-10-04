import 'package:flutter/material.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/home/magazine/model/magazine.dart';

class MagazineRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  Future<List<Magazine>> getMagazines() async {
    try {
      final response = await _dio.get('/magazine/');
      List<Magazine> magazines = response.data
          .map<Magazine>((item) => Magazine.fromJson(item))
          .toList();
      return magazines;
    } catch (e) {
      rethrow;
    }
  }

  Future<Magazine?> getMagazine(int magazineId) async {
    try {
      final response = await _dio.get('/magazine/$magazineId/');
      return Magazine.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Magazine?> createMagazine(Magazine magazine) async {
    try {
      final data = magazine.toJson();
      final response = await _dio.post('/magazine/create/', data: data);
      if (response.statusCode == 201) {
        return Magazine.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateMagazine(Magazine magazine) async {
    try {
      final response = await _dio.put(
        '/magazine/${magazine.magazineId}/update/',
        data: magazine.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMagazine(int magazineId) async {
    try {
      final response =
      await _dio.delete('/magazine/$magazineId/delete/', data: {'magazineId': magazineId});
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  Future<List<Magazine>> getLatestMagazine() async {
    try {
      final response = await _dio.get('/magazine/recent/');
      List<Magazine> news = response.data
          .map<Magazine>((item) => Magazine.fromJson(item))
          .toList();
      return news;
    } catch (e) {
      rethrow;
    }
  }
}
