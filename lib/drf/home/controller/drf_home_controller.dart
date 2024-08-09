import 'package:get/get.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';
import 'package:nero_app/drf/user/repository/drf_user_repository.dart';

class DrfHomeController extends GetxController {
  final DrfUserRepository userRepository;

  DrfHomeController({required this.userRepository});

  var user = Rxn<DrfUserModel>();

  @override
  void onInit() {
    super.onInit();
    String? userId = Get.arguments?['uid'];
    if (userId != null) {
      fetchUser(userId);
    } else {
      print('Error: User ID is null');
    }
  }

  void fetchUser(String userId) async {
    try {
      user.value = await userRepository.findUserOne(userId);
      print('Fetched user: ${user.value}');
    } catch (e) {
      print('Error fetching user: $e');
    }
  }
}
