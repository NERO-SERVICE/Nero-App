import 'package:dio/dio.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/mail/model/mail.dart';

class MailRepository {
  final DioService _dio = DioService();

  Future<bool> sendMail(Mail mail) async {
    try {
      final response = await _dio.post(
        '/mail/create/',
        data: mail.toJson(),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Failed to send mail: $e');
      return false;
    }
  }
}