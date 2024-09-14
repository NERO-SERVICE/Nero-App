import 'package:get/get.dart';

class SignUpController extends GetxController {
  var nickname = ''.obs;
  var email = ''.obs;
  var birth = ''.obs;
  var selectedSex = ''.obs;

  final List<String> sexOptions = ['여성', '남성', '기타'];
}