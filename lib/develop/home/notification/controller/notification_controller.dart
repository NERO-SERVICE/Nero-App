import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
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


  Future<void> fetchNotifications() async {
    isLoading.value = true;

    final result = await _notificationRepository.getNotifications();
    notifications.assignAll(result);

    isLoading.value = false;
  }


  Future<void> fetchNotification(int noticeId) async {
    isLoading.value = true;

    final notification = await _notificationRepository.getNotification(noticeId);
    if (notification != null) {
      currentNotification.value = notification;
    }

    isLoading.value = false;
  }


  Future<void> createNotification(NotificationModel notification) async {
    isLoading.value = true;
    try {
      final newNotification = await _notificationRepository.createNotification(notification);
      if (newNotification != null) {
        notifications.add(newNotification);
        CustomSnackbar.show(
          context: Get.context!,
          message: '공지사항이 생성되었습니다.',
          isSuccess: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '공지사항 생성을 실패했습니다.',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateNotification(NotificationModel notification) async {
    isLoading.value = true;
    try {
      final success = await _notificationRepository.updateNotification(notification);
      if (success) {
        int index = notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          notifications[index] = notification;
          CustomSnackbar.show(
            context: Get.context!,
            message: '공지사항이 수정되었습니다.',
            isSuccess: true,
          );
        }
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '공지사항 수정을 실패했습니다.',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteNotification(int noticeId) async {
    isLoading.value = true;
    try {
      final success = await _notificationRepository.deleteNotification(noticeId);
      if (success) {
        notifications.removeWhere((n) => n.id == noticeId);
        CustomSnackbar.show(
          context: Get.context!,
          message: '공지사항이 삭제되었습니다.',
          isSuccess: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '공지사항 삭제를 실패했습니다.',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
