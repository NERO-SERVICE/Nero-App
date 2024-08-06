import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/kakao/user/model/user_model.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${user.username}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nickname: ${user.nickname}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
