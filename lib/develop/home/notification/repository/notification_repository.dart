import 'package:flutter/material.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/home/notification/model/notification_model.dart';

class NotificationRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get('/notification/');
      print(response.data);

      // 서버에서 받아온 데이터 리스트를 NotificationModel로 변환
      List<NotificationModel> products = (response.data as List<dynamic>)
          .map((item) => NotificationModel.fromJson(item))
          .toList();
      return products;
    } catch (e) {
      print('공지 리스트를 불러오지 못했습니다: $e');
      rethrow;
    }
  }

  Future<NotificationModel?> getNotification(int noticeId) async {
    try {
      final response = await _dio.get('/notification/$noticeId/');
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      print('특정 공지를 불러오지 못했습니다: $e');
      return null;
    }
  }

  Future<NotificationModel?> createNotification(NotificationModel notification) async {
    try {
      final data = notification.toJson();
      print('Request Data: $data');

      final response = await _dio.post('/notification/create/', data: data);

      if (response.statusCode == 201) {
        return NotificationModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('공지 생성을 실패했습니다: $e');
      return null;
    }
  }

  Future<bool> updateNotification(NotificationModel notification) async {
    try {
      final response = await _dio.put(
        '/notification/${notification.id}/update/',
        data: notification.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to edit product: $e');
      return false;
    }
  }

  Future<bool> deleteNotification(int noticeId) async {
    try {
      final response =
      await _dio.delete('/notification/$noticeId/delete/', data: {'noticeId': noticeId});
      return response.statusCode == 204;
    } catch (e) {
      print('Failed to delete product: $e');
      return false;
    }
  }
}
