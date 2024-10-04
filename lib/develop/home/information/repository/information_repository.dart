import 'package:flutter/material.dart';
import 'package:nero_app/develop/dio_service.dart';

import '../model/information.dart';

class InformationRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  Future<List<Information>> getInformations() async {
    try {
      final response = await _dio.get('/information/');
      print(response.data);

      List<Information> informations = response.data
          .map<Information>((item) => Information.fromJson(item))
          .toList();
      return informations;
    } catch (e) {
      print('공지사항 리스트를 불러오지 못했습니다: $e');
      rethrow;
    }
  }

  Future<Information?> getInformation(int infoId) async {
    try {
      final response = await _dio.get('/information/$infoId/');
      return Information.fromJson(response.data);
    } catch (e) {
      print('특정 공지사항을 불러오지 못했습니다: $e');
      return null;
    }
  }

  Future<Information?> createInformation(Information information) async {
    try {
      final data = information.toJson();
      print('Request Data: $data');

      final response = await _dio.post('/information/create/', data: data);

      if (response.statusCode == 201) {
        return Information.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('공지사항 생성을 실패했습니다: $e');
      return null;
    }
  }

  Future<List<Information>> getLatestInformation() async {
    try {
      final response = await _dio.get('/information/recent/');
      print(response.data);

      List<Information> news = response.data
          .map<Information>((item) => Information.fromJson(item))
          .toList();
      return news;
    } catch (e) {
      print('최신 공지사항 4개를 불러오는데 실패했습니다: $e');
      rethrow;
    }
  }
}
