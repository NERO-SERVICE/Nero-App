import 'package:get/get.dart';
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
        print("Mail sent successfully");
      } else {
        print("Failed to send mail");
      }
    } catch (e) {
      print("Error while sending mail: $e");
    }
  }
}
