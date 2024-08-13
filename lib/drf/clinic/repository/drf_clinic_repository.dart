import 'package:flutter/material.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/dio_service.dart';

class DrfClinicRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  // 모든 클리닉 리스트 불러오기
  Future<List<DrfClinic>> getClinics() async {
    try {
      final response = await _dio.get('/clinics/lists/');
      print(response.data);

      List<DrfClinic> clinics = response.data
          .map<DrfClinic>((item) => DrfClinic.fromJson(item))
          .toList();
      return clinics;
    } catch (e) {
      print('Failed to load clinics: $e');
      rethrow;
    }
  }

  // 특정 클리닉 불러오기
  Future<DrfClinic?> getClinic(int clinicId) async {
    try {
      final response = await _dio.get('/clinics/$clinicId/');
      return DrfClinic.fromJson(response.data);
    } catch (e) {
      print('Failed to load clinic: $e');
      return null;
    }
  }

  // 클리닉 생성하기
  Future<DrfClinic?> createClinic(DrfClinic clinic) async {
    try {
      final data = clinic.toJson();
      print('Request Data: $data');

      final response = await _dio.post('/clinics/create/', data: data);

      if (response.statusCode == 201) {
        return DrfClinic.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to create clinic: $e');
      return null;
    }
  }

  // 클리닉 수정하기
  Future<bool> updateClinic(DrfClinic clinic) async {
    try {
      final response = await _dio.put(
        '/clinics/${clinic.clinicId}/update/',
        data: clinic.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to update clinic: $e');
      return false;
    }
  }

  // 클리닉 삭제하기
  Future<bool> deleteClinic(int clinicId) async {
    try {
      final response = await _dio.delete('/clinics/$clinicId/delete/');
      return response.statusCode == 204;
    } catch (e) {
      print('Failed to delete clinic: $e');
      return false;
    }
  }
}
