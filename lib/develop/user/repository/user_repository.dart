import 'package:get/get.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';

class UserRepository extends GetxService {
  final AuthenticationRepository authenticationRepository;

  UserRepository({required this.authenticationRepository});

  Future<NeroUser?> findUserOne(int userId) async {
    try {
      final tokens = await authenticationRepository.getDrfTokens();
      final String? accessToken = tokens['accessToken'];
      if (accessToken != null) {
        final response =
            await authenticationRepository.getUserInfoWithTokens(accessToken);
        return NeroUser.fromJson(response!);
      }
    } catch (e) {
      print('Error finding user: $e');
    }
    return null;
  }
}
