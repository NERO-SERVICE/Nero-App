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
      final response = await _dio.get('/clinics/lists/');
      print('Response Data: ${response.data}');  // 서버로부터 받은 데이터 출력

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
      print('Response Data: ${response.data}');  // 서버로부터 받은 데이터 출력
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
      print('Request Data: $data');  // 서버에 보낼 데이터 출력

      final response = await _dio.post('/clinics/create/', data: data);

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

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
      final data = clinic.toJson();
      print('Request Data: $data');  // 서버에 보낼 데이터 출력

      final response = await _dio.put(
        '/clinics/${clinic.clinicId}/update/',
        data: data,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');  // 서버로부터 받은 데이터 출력

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to update clinic: $e');
      return false;
    }
  }

  // 클리닉 삭제하기
  Future<bool> deleteClinic(int clinicId) async {
    try {
      print('Deleting clinic with ID: $clinicId');  // 삭제 요청 전 클리닉 ID 출력

      final response = await _dio.delete('/clinics/$clinicId/delete/');

      print('Response Status Code: ${response.statusCode}');
      return response.statusCode == 204;
    } catch (e) {
      print('Failed to delete clinic: $e');
      return false;
    }
  }

  // 가장 최근에 작성된 클리닉의 약물 리스트 불러오기
  Future<List<DrfDrug>> getDrugsFromLatestClinic() async {
    try {
      // 모든 클리닉을 불러오기
      List<DrfClinic> clinics = await getClinics();

      if (clinics.isEmpty) {
        print('No clinics available');
        return [];
      }

      // 가장 최근에 작성된 클리닉을 선택
      DrfClinic latestClinic = clinics.first;

      // 선택된 클리닉의 약물 리스트를 불러오기
      final response = await _dio.get('/clinics/${latestClinic.clinicId}/drugs/');
      print('Response Data: ${response.data}');  // 서버로부터 받은 데이터 출력

      List<DrfDrug> drugs = response.data
          .map<DrfDrug>((item) => DrfDrug.fromJson(item))
          .toList();
      return drugs;
    } catch (e) {
      print('Failed to load drugs: $e');
      rethrow;
    }
  }

  // 선택된 약물 소모 상태로 전송
  Future<bool> consumeSelectedDrugs(List<int> drugIds) async {
    try {
      print('Request Data: drug_ids = $drugIds');  // 서버에 보낼 데이터 출력

      final response = await _dio.post(
        '/clinics/drugs/consume/',
        data: {'drug_ids': drugIds},
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');  // 서버로부터 받은 데이터 출력

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to consume selected drugs: $e');
      return false;
    }
  }
}
