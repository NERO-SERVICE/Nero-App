import 'package:get/get.dart';
import 'package:nero_app/develop/home/notification/model/notification_model.dart';
import 'package:nero_app/develop/home/notification/repository/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _notificationRepository = NotificationRepository();
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var currentNotification = NotificationModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // 공지사항 리스트 가져오기
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final result = await _notificationRepository.getNotifications();
      notifications.assignAll(result);
    } catch (e) {
      print('공지사항을 불러오는 데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 특정 공지사항 가져오기
  Future<void> fetchNotification(int noticeId) async {
    isLoading.value = true;
    try {
      final notification = await _notificationRepository.getNotification(noticeId);
      if (notification != null) {
        currentNotification.value = notification;
      }
    } catch (e) {
      print('특정 공지를 불러오는 데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 공지사항 생성 (로그인한 유저가 writer로 설정됨)
  Future<void> createNotification(NotificationModel notification) async {
    isLoading.value = true;
    try {
      final newNotification = await _notificationRepository.createNotification(notification);
      if (newNotification != null) {
        notifications.add(newNotification);
        Get.snackbar('성공', '공지사항이 성공적으로 생성되었습니다.');
      }
    } catch (e) {
      Get.snackbar('실패', '공지사항 생성에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 공지사항 수정
  Future<void> updateNotification(NotificationModel notification) async {
    isLoading.value = true;
    try {
      final success = await _notificationRepository.updateNotification(notification);
      if (success) {
        int index = notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          notifications[index] = notification;
          Get.snackbar('성공', '공지사항이 성공적으로 수정되었습니다.');
        }
      }
    } catch (e) {
      Get.snackbar('실패', '공지사항 수정에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 공지사항 삭제
  Future<void> deleteNotification(int noticeId) async {
    isLoading.value = true;
    try {
      final success = await _notificationRepository.deleteNotification(noticeId);
      if (success) {
        notifications.removeWhere((n) => n.id == noticeId);
        Get.snackbar('성공', '공지사항이 성공적으로 삭제되었습니다.');
      }
    } catch (e) {
      Get.snackbar('실패', '공지사항 삭제에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}
