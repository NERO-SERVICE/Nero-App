import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/signup/repository/sign_up_repository.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';

class SignUpController extends GetxController {
  var nickname = ''.obs;
  var email = ''.obs;
  var birth = ''.obs;
  var selectedSex = ''.obs;

  final SignUpRepository _signUpRepository = SignUpRepository();

  Future<void> updateUserInfo(NeroUser currentUser) async {
    try {
      // birth 값을 String에서 DateTime으로 변환
      DateTime? birthDate = _parseBirth(birth.value);

      final updatedUser = currentUser.copyWith(
        nickname: nickname.value.isNotEmpty ? nickname.value : currentUser.nickname,
        email: email.value.isNotEmpty ? email.value : currentUser.email,
        birth: birthDate,
        sex: selectedSex.value.isNotEmpty ? selectedSex.value : currentUser.sex,
      );

      bool success = await _signUpRepository.settingUserInfo(updatedUser);

      if (success) {
        print('유저 정보가 성공적으로 업데이트되었습니다.');
      } else {
        print('유저 정보 업데이트 실패.');
      }
    } catch (e) {
      print('유저 정보 업데이트 중 오류 발생: $e');
    }
  }

  // 'YYMMDD' 형식을 'DateTime'으로 변환
  DateTime? _parseBirth(String birthInput) {
    if (birthInput.length == 6) {
      try {
        String prefix = int.parse(birthInput.substring(0, 2)) > 21 ? '19' : '20';
        String formattedBirth = '$prefix${birthInput.substring(0, 2)}-${birthInput.substring(2, 4)}-${birthInput.substring(4, 6)}';
        return DateFormat('yyyy-MM-dd').parse(formattedBirth);
      } catch (e) {
        print('생년월일 변환 중 오류 발생: $e');
        return null;
      }
    }
    return null;
  }
}
