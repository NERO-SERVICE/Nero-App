import 'package:flutter/material.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/model/health.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthController()..initialize(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('걸음 수 정보'),
          backgroundColor: Colors.black, // 배경색을 어둡게 설정
        ),
        backgroundColor: Colors.black, // 전체 배경색을 어둡게 설정
        body: Consumer<HealthController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.error != null) {
              return Center(
                child: Text(
                  '오류 발생: ${controller.error}',
                  style: TextStyle(color: Colors.white), // 글자색을 흰색으로
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 오늘의 걸음 수 표시
                  Text(
                    '오늘의 걸음 수: ${controller.todaySteps}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 글자색을 흰색으로
                    ),
                  ),
                  SizedBox(height: 20),
                  // 걸음 수 그래프
                  Expanded(
                    child: StepsChart(stepData: controller.stepsHistory),
                  ),
                  SizedBox(height: 20),
                  // 걸음 수 데이터 수집 및 저장 버튼
                  ElevatedButton(
                    onPressed: () async {
                      DateTime endDate = DateTime.now();
                      DateTime startDate = endDate.subtract(Duration(days: 7));
                      await controller.collectAndSaveSteps(
                        startDate: startDate,
                        endDate: endDate,
                      );
                    },
                    child: Text(
                      '걸음 수 데이터 수집 및 저장',
                      style: TextStyle(color: Colors.white), // 글자색을 흰색으로
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // 버튼 배경색
                    ),
                  ),
                ],
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
          style: TextStyle(color: Colors.white), // 글자색을 흰색으로
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
    double maxY = stepData.map((e) => e.steps).reduce((a, b) => a > b ? a : b).toDouble();
    maxY = (maxY + 1000);

    return LineChart(
      LineChartData(
        maxY: maxY,
        minY: 0,
        backgroundColor: Colors.black, // 그래프 배경색
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.2), // 그리드 라인 색상
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index >= 0 && index < xLabels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      xLabels[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY / 5).ceilToDouble(),
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(
              show: true,
            ),
            // 데이터 포인트 위에 걸음 수 표시
            showingIndicators: List.generate(spots.length, (index) => index),
          ),
        ],
        // 데이터 포인트 위에 걸음 수 표시하기 위한 extraLinesData
        extraLinesData: ExtraLinesData(
          extraLinesOnTop: true,
          horizontalLines: List.generate(spots.length, (index) {
            return HorizontalLine(
              y: spots[index].y,
              color: Colors.transparent,
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.bottomCenter,
                labelResolver: (line) => '${spots[index].y.toInt()}',
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
        ),
      ),
    );
  }
}