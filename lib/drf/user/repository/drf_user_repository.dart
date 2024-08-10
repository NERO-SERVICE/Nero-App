import 'package:get/get.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';

class DrfUserRepository extends GetxService {
  final DrfAuthenticationRepository drfAuthenticationRepository;

  DrfUserRepository({required this.drfAuthenticationRepository});

  Future<DrfUserModel?> findUserOne(String uid) async {
    try {
      final response = await drfAuthenticationRepository.getUserInfo(uid);
      return DrfUserModel.fromJson(response);
    } catch (e) {
      print('Error finding user: $e');
      return null;
    }
  }
}
