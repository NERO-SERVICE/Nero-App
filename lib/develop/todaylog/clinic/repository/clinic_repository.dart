import 'package:flutter/material.dart';
import 'package:nero_app/develop/dio_service.dart';

import '../model/clinic.dart';
import '../model/drug.dart';
import '../model/drug_archive.dart';
import '../model/my_drug_archive.dart';

class ClinicRepository {
  final DioService _dio = DioService();
  ScrollController scrollController = ScrollController();

  // 모든 클리닉 리스트 불러오기
  Future<List<Clinic>> getClinics() async {
    try {
      final response = await _dio.get('/clinics/lists/');
      print('Response Data: ${response.data}');

      List<Clinic> clinics =
          response.data.map<Clinic>((item) => Clinic.fromJson(item)).toList();
      return clinics;
    } catch (e) {
      print('클리닉 리스트를 불러오지 못했습니다: $e');
      rethrow;
    }
  }

  // 특정 클리닉 불러오기
  Future<Clinic?> getClinic(int clinicId) async {
    try {
      final response = await _dio.get('/clinics/$clinicId/');
      print('Response Data: ${response.data}');
      return Clinic.fromJson(response.data);
    } catch (e) {
      print('특정 클리닉을 불러오지 못했습니다: $e');
      return null;
    }
  }

  // 클리닉 생성하기
  Future<Clinic?> createClinic(Clinic clinic) async {
    try {
      final data = clinic.toJson();
      print('Request Data: $data');

      // DrfMyDrugArchive 사용
      data['drugs'] = clinic.drugs.map((drug) {
        return {
          'myDrugArchive': drug.myDrugArchive.toJson(),
          'number': drug.number,
          'initialNumber': drug.initialNumber,
          'time': drug.time,
          'allow': drug.allow,
        };
      }).toList();

      final response = await _dio.post('/clinics/create/', data: data);

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 201) {
        return Clinic.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('클리닉을 생성하지 못했습니다: $e');
      return null;
    }
  }

  // 클리닉 수정하기
  Future<bool> updateClinic(Clinic clinic) async {
    try {
      final data = clinic.toJson();
      print('Request Data: $data');

      // DrfMyDrugArchive 사용
      data['drugs'] = clinic.drugs.map((drug) {
        return {
          ...drug.toJson(),
          'myDrugArchive': drug.myDrugArchive.myArchiveId,
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
      print('클리닉을 수정하지 못했습니다: $e');
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
      print('클리닉을 삭제하지 못했습니다: $e');
      return false;
    }
  }

  // 약물 아카이브 리스트 불러오기 (DrugArchive)
  Future<List<DrugArchive>> getDrugArchives() async {
    try {
      final response = await _dio.get('/clinics/drugs/archives/');
      List<DrugArchive> archives = response.data
          .map<DrugArchive>((item) => DrugArchive.fromJson(item))
          .toList();
      return archives;
    } catch (e) {
      print('약물 모음을 불러오지 못했습니다: $e');
      rethrow;
    }
  }

  // 약물 리스트 불러오기 (최신 클리닉) (MyDrugArchive 사용)
  Future<List<Drug>> getDrugsFromLatestClinic() async {
    try {
      List<Clinic> clinics = await getClinics();
      if (clinics.isEmpty) {
        return [];
      }
      Clinic latestClinic = clinics.first;
      final response =
          await _dio.get('/clinics/${latestClinic.clinicId}/drugs/');

      // 여기서 DrfMyDrugArchive로 변환
      List<Drug> drugs = (response.data as List<dynamic>).map<Drug>((item) {
        return Drug(
          drugId: item['drugId'],
          myDrugArchive: MyDrugArchive.fromJson(item['myDrugArchive']),
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
