import 'package:flutter/material.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/model/drf_drug_archive.dart';
import 'package:nero_app/drf/dio_service.dart';

class DrfClinicRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  // 모든 클리닉 리스트 불러오기
  Future<List<DrfClinic>> getClinics() async {
    try {
      final response = await _dio.get('/clinics/lists/');
      print('Response Data: ${response.data}');

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
      print('Response Data: ${response.data}');
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

      data['drugs'] = clinic.drugs.map((drfDrug) {
        return {
          ...drfDrug.toJson(),
          'drugArchive': drfDrug.drugArchive.id,
        };
      }).toList();

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
      print('Request Data: $data');

      // drugArchive는 단일 객체로 처리
      data['drugs'] = clinic.drugs.map((drfDrug) {
        return {
          ...drfDrug.toJson(),
          'drugArchive': drfDrug.drugArchive.id,
        };
      }).toList();

      final response = await _dio.put(
        '/clinics/${clinic.clinicId}/update/',
        data: data,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to update clinic: $e');
      return false;
    }
  }

  // 클리닉 삭제하기
  Future<bool> deleteClinic(int clinicId) async {
    try {
      print('Deleting clinic with ID: $clinicId');

      final response = await _dio.delete('/clinics/$clinicId/delete/');

      print('Response Status Code: ${response.statusCode}');
      return response.statusCode == 204;
    } catch (e) {
      print('Failed to delete clinic: $e');
      return false;
    }
  }

  // 약물 아카이브 리스트 불러오기
  Future<List<DrfDrugArchive>> getDrugArchives() async {
    try {
      final response = await _dio.get('/clinics/drugs/archives/');
      List<DrfDrugArchive> archives = response.data
          .map<DrfDrugArchive>((item) => DrfDrugArchive.fromJson(item))
          .toList();
      return archives;
    } catch (e) {
      print('Failed to load drug archives: $e');
      rethrow;
    }
  }

  // 약물 리스트 불러오기 (최신 클리닉)
  Future<List<DrfDrug>> getDrugsFromLatestClinic() async {
    try {
      List<DrfClinic> clinics = await getClinics();
      if (clinics.isEmpty) {
        return [];
      }
      DrfClinic latestClinic = clinics.first;
      final response = await _dio.get('/clinics/${latestClinic.clinicId}/drugs/');

      // drugArchive는 JSON 객체이므로, 이를 DrfDrugArchive 객체로 변환
      List<DrfDrug> drugs = (response.data as List<dynamic>).map<DrfDrug>((item) {
        return DrfDrug(
          drugId: item['drugId'],
          drugArchive: DrfDrugArchive.fromJson(item['drugArchive']), // 여기서 변환
          number: item['number'],
          initialNumber: item['initialNumber'],
          time: item['time'],
          allow: item['allow'],
        );
      }).toList();

      return drugs;
    } catch (e) {
      rethrow;
    }
  }


  // 선택된 약물 소모 상태로 전송
  Future<bool> consumeSelectedDrugs(List<int> drugIds) async {
    try {
      final response = await _dio.post(
        '/clinics/drugs/consume/',
        data: {'drug_ids': drugIds},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
