import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/fastmemo/model/fastmemo.dart';

class FastmemoRepository {
  final DioService _dioService = Get.find<DioService>();

  Future<List<Fastmemo>> getFastmemo(DateTime date) async {
    final response = await _dioService.get('/fastlogs/', params: {
      'year': date.year.toString(),
      'month': date.month.toString().padLeft(2, '0'),
      'day': date.day.toString().padLeft(2, '0'),
    });
    return (response.data as List).map((e) => Fastmemo.fromJson(e)).toList();
  }

  Future<Set<DateTime>> getMemoDates(int year) async {
    final response = await _dioService.get('/fastlogs/dates/', params: {
      'year': year.toString(),
    });
    return (response.data as List).map((dateStr) => DateTime.parse(dateStr)).toSet();
  }

  Future<Fastmemo> createFastmemo(String content, String formattedDate) async {
    final response = await _dioService.post('/fastlogs/', data: {
      'content': content,
      'date': formattedDate,
    });
    return Fastmemo.fromJson(response.data);
  }

  Future<void> updateFastmemo(int id, String content) async {
    await _dioService.patch('/fastlogs/$id/', data: {'content': content});
  }

  Future<void> deleteFastmemo(int id) async {
    await _dioService.delete('/fastlogs/$id/');
  }

  Future<void> bulkUpdateIsChecked(bool isChecked, List<int> ids) async {
    await _dioService.post('/fastlogs/bulk/', data: {
      'ids': ids,
      'is_checked': isChecked,
    });
  }

  Future<void> bulkDeleteFastmemo(List<int> ids) async {
    await _dioService.delete('/fastlogs/bulk/', data: {
      'ids': ids,
    });
  }
}
