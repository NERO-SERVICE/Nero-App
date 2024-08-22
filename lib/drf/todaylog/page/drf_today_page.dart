import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drf_today_log_page.dart';
import 'drf_today_self_log_page.dart';
import 'drf_today_side_effect_page.dart';

class DrfTodayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DrfTodayController()),
        ],
        child: CommonLayout(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: Get.width * 0.6,
            leading: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
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
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
                _buildCustomButton(
                  context,
                  icon: Icons.question_answer,
                  label: '하루 설문',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DrfTodayLogPage()),
                    );
                  },
                ),
                SizedBox(height: 16),
                _buildCustomButton(
                  context,
                  icon: Icons.warning,
                  label: '부작용 기록',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrfTodaySideEffectPage()),
                    );
                  },
                ),
                SizedBox(height: 16),
                _buildCustomButton(
                  context,
                  icon: Icons.edit,
                  label: '셀프 기록',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrfTodaySelfLogPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCustomButton(BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 100,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}