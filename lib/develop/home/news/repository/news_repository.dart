import 'package:flutter/material.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/home/news/model/news.dart';

class NewsRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  Future<List<News>> getLatestNews() async {
    try {
      final response = await _dio.get('/news/latest/');
      print(response.data);

      List<News> news = response.data
          .map<News>((item) => News.fromJson(item))
          .toList();
      return news;
    } catch (e) {
      print('Failed to load latest news: $e');
      rethrow;
    }
  }

  Future<List<News>> getNewsPage(int page) async {
    try {
      final response = await _dio.get('/news/', params: {'page': page});
      print(response.data);

      List<News> news = response.data['results']
          .map<News>((item) => News.fromJson(item))
          .toList();
      return news;
    } catch (e) {
      print('Failed to load news: $e');
      rethrow;
    }
  }
}
