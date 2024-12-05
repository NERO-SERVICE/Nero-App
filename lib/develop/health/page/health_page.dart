import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/model/health.dart';
import 'package:nero_app/develop/health/page/health_video_info_page.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthController()..initialize(),
      child: Scaffold(
        appBar: CustomDetailAppBar(
          title: '걸음 수 정보',
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Consumer<HealthController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.error != null) {
              return Center(
                child: Text(
                  '오류 발생: ${controller.error}',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    StepsChart(stepData: controller.stepsHistory),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.stepsHistory.length,
                      itemBuilder: (context, index) {
                        final stepCount = controller.stepsHistory[index];
                        return ListTile(
                          title: Text(
                            DateFormat('yyyy년 MM월 dd일').format(stepCount.date),
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          trailing: Text(
                            '${stepCount.steps} 걸음',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.titleColor,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HealthVideoInfoPage(),
                          ),
                        );
                      },
                      child: Text(
                        '운동 동영상 보기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.activeButtonColor,
                        elevation: 0,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StepsChart extends StatelessWidget {
  final List<StepCount> stepData;

  StepsChart({required this.stepData});

  @override
  Widget build(BuildContext context) {
    if (stepData.isEmpty) {
      return Center(
        child: Text(
          '걸음 수 데이터가 없습니다.',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.primaryTextColor,
          ),
        ),
      );
    }

    // 날짜 순으로 정렬
    stepData.sort((a, b) => a.date.compareTo(b.date));

    // X축 라벨 및 데이터 생성
    List<String> xLabels =
    stepData.map((e) => DateFormat('MM/dd').format(e.date)).toList();

    // 데이터 포인트 생성
    List<FlSpot> spots = [];
    for (int i = 0; i < stepData.length; i++) {
      spots.add(FlSpot(i.toDouble(), stepData[i].steps.toDouble()));
    }

    // Y축 최대값 설정
    double maxY = stepData
        .map((e) => e.steps)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    maxY = (maxY + 1000);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        height: 250, // 그래프 높이
        child: LineChart(
          LineChartData(
            maxY: maxY,
            minY: 0,
            backgroundColor: AppColors.backgroundColor,
            borderData: FlBorderData(
              show: false, // 테두리 표시 안함
            ),
            gridData: FlGridData(
              show: false, // 그리드 라인 숨기기
            ),
            titlesData: FlTitlesData(
              show: false,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false, // 왼쪽 Y축 라벨 숨기기
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                gradient: LinearGradient(
                  colors: [AppColors.titleColor, AppColors.primaryColor],
                ),
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.7),
                      AppColors.primaryColor.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  applyCutOffY: false,
                ),
                dotData: FlDotData(
                  show: true,
                ),
              ),
            ],
            // 터치 시 값 표시를 위한 설정
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (group) => AppColors.inactiveButtonColor,
                tooltipRoundedRadius: 8,
                tooltipPadding: EdgeInsets.all(12), // 툴팁 내부 패딩
                tooltipMargin: 32, // 툴팁과 그래프 간 거리
                fitInsideHorizontally: true, // 툴팁이 가로로 그래프 안에 맞게 조정
                fitInsideVertically: true, // 툴팁이 세로로 그래프 안에 맞게 조정
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    final textStyle = TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    );
                    return LineTooltipItem(
                      '${xLabels[touchedSpot.x.toInt()]}\n${touchedSpot.y.toInt()} 걸음',
                      textStyle,
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
          ),
        ),
      ),
    );
  }
}
