import 'package:flutter/material.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:provider/provider.dart';
import 'drf_today_log_page.dart';
import 'drf_today_side_effect_page.dart';
import 'drf_today_self_log_page.dart';

class DrfTodayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrfTodayController()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('오늘의 관리'),
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
                    MaterialPageRoute(builder: (context) => DrfTodaySideEffectPage()),
                  );
                },
                child: Text('부작용 기록'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DrfTodaySelfLogPage()),
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
