import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/mail/model/mail.dart';
import 'package:nero_app/develop/mail/repository/mail_repository.dart';

class MailController extends GetxController {
  final MailRepository _mailRepository = MailRepository();
  var suggestion = ''.obs;

  Future<void> sendMail() async {
    try {
      final Mail mail = Mail(
        createdAt: DateTime.now(),
        suggestion: suggestion.value,
      );

      bool isSuccess = await _mailRepository.sendMail(mail);
      if (isSuccess) {
        CustomSnackbar.show(
          context: Get.context!,
          message: '소중한 건의 감사합니다!',
          isSuccess: true,
        );
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: '건의 전송에 실패했습니다.',
          isSuccess: false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '건의 전송에 오류가 있습니다.',
        isSuccess: false,
      );
    }
  }
}
