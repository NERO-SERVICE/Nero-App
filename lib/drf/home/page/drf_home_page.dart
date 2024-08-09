import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/api_service.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';
import 'package:nero_app/drf/user/repository/drf_user_repository.dart';

class DrfHomePage extends StatefulWidget {
  const DrfHomePage({Key? key}) : super(key: key);

  @override
  _DrfHomePageState createState() => _DrfHomePageState();
}

class _DrfHomePageState extends State<DrfHomePage> {
  late DrfUserRepository userRepository;
  var user = Rxn<DrfUserModel>();

  @override
  void initState() {
    super.initState();
    userRepository = Get.put(DrfUserRepository(apiService: Get.find()));

    String? userId = Get.arguments['uid'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DRF Home Page'),
      ),
      body: Center(
        child: Obx(() {
          if (user.value == null) {
            return const CircularProgressIndicator();
          } else {
            final userInfo = user.value!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nickname: ${userInfo.nickname ?? 'No nickname'}',
                    style: TextStyle(color: Colors.white)),
                Text('User ID: ${userInfo.uid ?? 'No ID'}',
                    style: TextStyle(color: Colors.white)),
                Text('Kakao ID: ${userInfo.kakaoId ?? 'No Kakao ID'}',
                    style: TextStyle(color: Colors.white)),
                Text('Temperature: ${userInfo.temperature ?? 'No temperature'}',
                    style: TextStyle(color: Colors.white)),
                Text('Created At: ${userInfo.createdAt?.toString() ??
                    'No date'}', style: TextStyle(color: Colors.white)),
                Text('Updated At: ${userInfo.updatedAt?.toString() ??
                    'No date'}', style: TextStyle(color: Colors.white)),
              ],
            );
          }
        }),
      ),
    );
  }
}