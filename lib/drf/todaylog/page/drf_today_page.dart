import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drf_today_log_page.dart';
import 'drf_today_self_log_page.dart';
import 'drf_today_side_effect_page.dart';

class DrfTodayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrfTodayController()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: Get.width * 0.6,
          leading: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(children: [
              const AppFont(
                '하루기록',
                fontWeight: FontWeight.bold,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
            ],
            ),
          ),
          actions: [
            SvgPicture.asset('assets/svg/icons/search.svg'),
            const SizedBox(width: 15),
            SvgPicture.asset('assets/svg/icons/list.svg'),
            const SizedBox(width: 15),
            IconButton(
              icon: Icon(Icons.logout,color: Colors.white,),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('accessToken');
                await prefs.remove('refreshToken');
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DrfTodayLogPage()),
                  );
                },
                child: Text('하루 설문'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrfTodaySideEffectPage()),
                  );
                },
                child: Text('부작용 기록'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrfTodaySelfLogPage()),
                  );
                },
                child: Text('셀프 기록'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
