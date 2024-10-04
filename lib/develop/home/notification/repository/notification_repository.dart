import 'package:flutter/material.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/home/notification/model/notification_model.dart';

class NotificationRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get('/notification/');

      List<NotificationModel> products = (response.data as List<dynamic>)
          .map((item) => NotificationModel.fromJson(item))
          .toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationModel?> getNotification(int noticeId) async {
    try {
      final response = await _dio.get('/notification/$noticeId/');
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<NotificationModel?> createNotification(NotificationModel notification) async {
    try {
      final data = notification.toJson();
      final response = await _dio.post('/notification/create/', data: data);

      if (response.statusCode == 201) {
        return NotificationModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
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
      return false;
    }
  }

  Future<bool> deleteNotification(int noticeId) async {
    try {
      final response =
      await _dio.delete('/notification/$noticeId/delete/', data: {'noticeId': noticeId});
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
