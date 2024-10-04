import 'package:flutter/material.dart';
import 'package:nero_app/develop/dio_service.dart';

import '../model/information.dart';

class InformationRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  Future<List<Information>> getInformations() async {
    try {
      final response = await _dio.get('/information/');
      List<Information> informations = response.data
          .map<Information>((item) => Information.fromJson(item))
          .toList();
      return informations;
    } catch (e) {
      rethrow;
    }
  }

  Future<Information?> getInformation(int infoId) async {
    try {
      final response = await _dio.get('/information/$infoId/');
      return Information.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Information?> createInformation(Information information) async {
    try {
      final data = information.toJson();
      final response = await _dio.post('/information/create/', data: data);

      if (response.statusCode == 201) {
        return Information.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Information>> getLatestInformation() async {
    try {
      final response = await _dio.get('/information/recent/');
      List<Information> news = response.data
          .map<Information>((item) => Information.fromJson(item))
          .toList();
      return news;
    } catch (e) {
      rethrow;
    }
  }
}
