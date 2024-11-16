import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';

import '../model/clinic.dart';
import '../model/drug.dart';
import '../model/drug_archive.dart';
import '../model/my_drug_archive.dart';

class ClinicRepository {
  final DioService _dio = Get.find<DioService>();
  ScrollController scrollController = ScrollController();

  Future<List<Clinic>> fetchClinics() async {
    try {
      final response = await _dio.get('/clinics/lists/');
      List<Clinic> clinics =
      response.data.map<Clinic>((item) => Clinic.fromJson(item)).toList();
      return clinics;
    } catch (e) {
      rethrow;
    }
  }

  Future<Clinic?> getClinic(int clinicId) async {
    try {
      final response = await _dio.get('/clinics/$clinicId/');
      return Clinic.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Clinic?> createClinic(Clinic clinic) async {
    try {
      final data = clinic.toJson();

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

      if (response.statusCode == 201) {
        return Clinic.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  Future<bool> updateClinic(Clinic clinic) async {
    try {
      final data = clinic.toJson();

      data['drugs'] = clinic.drugs.map((drug) {
        return {
          'myDrugArchive': drug.myDrugArchive.myArchiveId,
          ...drug.toJson(),
        };
      }).toList();

      final response = await _dio.put(
        '/clinics/${clinic.clinicId}/update/',
        data: data,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('클리닉을 업데이트하지 못했습니다: $e');
      return false;
    }
  }


  Future<bool> deleteClinic(int clinicId) async {
    try {
      print('Deleting clinic with ID: $clinicId');

      final response = await _dio.delete('/clinics/$clinicId/delete/');

      return response.statusCode == 204;
    } catch (e) {
      print('클리닉을 삭제하지 못했습니다: $e');
      return false;
    }
  }


  Future<List<DrugArchive>> getDrugArchives() async {
    try {
      final response = await _dio.get('/clinics/drugs/archives/');
      List<DrugArchive> archives = response.data
          .map<DrugArchive>((item) => DrugArchive.fromJson(item))
          .toList();
      return archives;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DrugArchive>> searchDrugArchives(String query) async {
    try {
      final response = await _dio.get(
        '/clinics/drugs/archives/',
        params: {'search': query},
      );
      List<DrugArchive> archives = (response.data as List)
          .map<DrugArchive>((item) => DrugArchive.fromJson(item))
          .toList();
      return archives;
    } catch (e) {
      rethrow;
    }
  }


  Future<List<Drug>> getDrugsFromLatestClinic() async {
    try {
      List<Clinic> clinics = await fetchClinics();
      if (clinics.isEmpty) {
        return [];
      }
      Clinic latestClinic = clinics.first;
      final response =
      await _dio.get('/clinics/${latestClinic.clinicId}/drugs/');


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


  Future<bool> rollbackConsumedDrugs(String date) async {
    try {
      final response = await _dio.post(
        '/clinics/drugs/consume/rollback/',
        data: {'date': date},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
