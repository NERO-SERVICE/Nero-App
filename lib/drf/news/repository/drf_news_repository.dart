import 'package:flutter/material.dart';
import 'package:nero_app/drf/news/model/drf_news.dart';
import 'package:nero_app/drf/dio_service.dart';

class DrfNewsRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  // 최신 뉴스 4개 불러오기
  Future<List<DrfNews>> getLatestNews() async {
    try {
      final response = await _dio.get('/news/latest/');
      print(response.data);

      List<DrfNews> news = response.data
          .map<DrfNews>((item) => DrfNews.fromJson(item))
          .toList();
      return news;
    } catch (e) {
      print('Failed to load latest news: $e');
      rethrow;
    }
  }

  // 뉴스 목록을 페이지네이션하여 불러오기
  Future<List<DrfNews>> getNewsPage(int page) async {
    try {
      final response = await _dio.get('/news/', params: {'page': page});
      print(response.data);

      List<DrfNews> news = response.data['results']
          .map<DrfNews>((item) => DrfNews.fromJson(item))
          .toList();
      return news;
    } catch (e) {
      print('Failed to load news: $e');
      rethrow;
    }
  }
}
