import 'package:get/get.dart';

import '../../controller/user_repository.dart';
import '../../model/user_model.dart';

class SignupController extends GetxController {
  final UserRepository _userRepository;
  final String uid;

  SignupController(this._userRepository, this.uid);

  RxString userNickName = ''.obs;
  RxBool isPossibleUseNickName = false.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(userNickName, checkDuplicationNickName,
        time: const Duration(milliseconds: 500));
  }

  checkDuplicationNickName(String value) async{
    var isPossibleUse = await _userRepository.checkDuplicationNickName(value);
    isPossibleUseNickName(isPossibleUse);
  }

  changeNickName(String nickName) {
    userNickName(nickName);
  }

  signup() async{
    var newUser = UserModel.create(userNickName.value, uid);
    var result = await _userRepository.signup(newUser);
    return result;
  }
}