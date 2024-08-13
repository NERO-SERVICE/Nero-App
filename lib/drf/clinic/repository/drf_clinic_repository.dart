import 'package:flutter/material.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/dio_service.dart';

class DrfClinicRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  // 모든 클리닉 리스트 불러오기
  Future<List<DrfClinic>> getClinics() async {
    try {
      final response = await _dio.get('/clinics/');
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

      final response = await _dio.post('/clinics/', data: data);

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

  // 특정 클리닉에 대한 약물 리스트 불러오기
  Future<List<DrfDrug>> getDrugs(int clinicId) async {
    try {
      final response = await _dio.get('/clinics/$clinicId/drugs/');
      print(response.data);

      List<DrfDrug> drugs =
          response.data.map<DrfDrug>((item) => DrfDrug.fromJson(item)).toList();
      return drugs;
    } catch (e) {
      print('Failed to load drugs: $e');
      rethrow;
    }
  }

  // 특정 클리닉에 약물 추가하기
  Future<DrfDrug?> createDrug(int clinicId, DrfDrug drug) async {
    try {
      final data = drug.toJson();
      print('Request Data: $data');

      final response = await _dio.post('/clinics/$clinicId/drugs/', data: data);

      if (response.statusCode == 201) {
        return DrfDrug.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to create drug: $e');
      return null;
    }
  }

  // 특정 약물 수정하기
  Future<bool> updateDrug(int clinicId, DrfDrug drug) async {
    try {
      final response = await _dio.put(
        '/clinics/$clinicId/drugs/${drug.drugId}/',
        data: drug.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to update drug: $e');
      return false;
    }
  }

  // 특정 약물 삭제하기
  Future<bool> deleteDrug(int clinicId, int drugId) async {
    try {
      final response = await _dio.delete('/clinics/$clinicId/drugs/$drugId/');
      return response.statusCode == 204;
    } catch (e) {
      print('Failed to delete drug: $e');
      return false;
    }
  }
}
