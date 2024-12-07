import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/enum/waste_emoji.dart';
import 'package:nero_app/develop/health/model/health.dart';
import 'package:nero_app/develop/health/model/predicted_steps_data.dart';
import 'package:nero_app/develop/health/page/health_video_info_page.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HealthPage extends StatelessWidget {
  String formatSteps(int? steps) {
    if (steps == null) return '-';
    if (steps >= 1000) {
      return NumberFormat('#,###').format(steps);
    }
    return steps.toString();
  }

  Widget _healthTitle({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xffD9D9D9),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildManualStepInput(BuildContext context, DateTime date) {
    final _stepsController = TextEditingController();
    final controller = Provider.of<HealthController>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              DateFormat('yyyy년 MM월 dd일').format(date),
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: 80,
            child: TextField(
              controller: _stepsController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.titleColor,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.hintTextColor,
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Color(0xFFD0EE17),
                    width: 1,
                  ),
                ),
                isDense: true,
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              final inputSteps = int.tryParse(_stepsController.text);
              if (inputSteps == null || inputSteps < 0) {
                CustomSnackbar.show(
                    context: context, message: '유효한 걸음 수를 입력해주세요.', isSuccess: false);
                return;
              }

              bool success = await controller.updateSteps(inputSteps, date);
              if (success) {
                // CustomSnackbar.show(
                //     context: context, message: '걸음 수가 성공적으로 저장되었습니다.', isSuccess: true);
              } else {
                CustomSnackbar.show(
                    context: context, message: '걸음 수 저장에 실패했습니다', isSuccess: false);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: AppColors.dialogBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              '저장',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildUserInfoContainer(PredictedStepsData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.activeButtonColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '나는 ',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  TextSpan(
                    text: '${data.ageGroup}0대 ',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.titleColor,
                    ),
                  ),
                  TextSpan(
                    text: data.gender ?? '-',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.titleColor,
                    ),
                  ),
                  TextSpan(
                    text: '에 속해요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '다른 사람들보다 더 ',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  TextSpan(
                    text: '${data.comparisonFlag == 0 ? '적게' : '많이'} ',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: data.comparisonFlag == 0
                          ? Color(0xffFF5A5A)
                          : Color(0xff69ACF5),
                    ),
                  ),
                  TextSpan(
                    text: '걸어요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '평균 걸음과 ',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  TextSpan(
                    text: '${formatSteps(data.difference)} 걸음',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.titleColor,
                    ),
                  ),
                  TextSpan(
                    text: ' 차이가 나요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'BMI 결과 등급은 ',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  TextSpan(
                    text: '${data.bmiGrade ?? '-'} ',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.titleColor, // 강조 색상
                    ),
                  ),
                  TextSpan(
                    text: '이에요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObesityRiskContainer(
      PredictedStepsData data, String emojiAssetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.activeButtonColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '비만 동반질환** 위험도',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.waistRisk ?? '-',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(width: 16),
                Image.asset(
                  emojiAssetPath,
                  width: 36,
                  height: 36,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieContainer(PredictedStepsData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.activeButtonColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '맞춤형 칼로리 계산',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 24),
            Image.asset(
              'assets/develop/fire.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '느린 걷기 (2km/h)',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.hintTextColor,
                  ),
                ),
                Text(
                  '${data.slowWalkCal} kcal',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.titleColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '보통 걷기 (4km/h)',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.hintTextColor,
                  ),
                ),
                Text(
                  '${data.normalWalkCal} kcal',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.titleColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '빠른 걷기 (6km/h)',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.hintTextColor,
                  ),
                ),
                Text(
                  '${data.fastWalkCal} kcal',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.titleColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(
      BuildContext context, {
        required String labelTop,
        required String labelBottom,
        required VoidCallback onPressed,
        EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: const Color(0xff323232),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelTop,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labelBottom,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xffD0EE17),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthController()..initialize(),
      child: Scaffold(
        appBar: CustomDetailAppBar(
          title: '건강 정보 (Beta)',
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Consumer<HealthController>(
          builder: (context, controller, child) {
            if (controller.isLoading && controller.stepsHistory.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.error != null && controller.stepsHistory.isEmpty) {
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

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        StepsChart(stepData: controller.stepsHistory),
                        SizedBox(height: 36),
                        Container(
                          child: Text(
                            '최근 7일 걸음 데이터',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.stepsHistory.length,
                          itemBuilder: (context, index) {
                            final stepCount = controller.stepsHistory[index];
                            if (stepCount.steps == 0) {
                              return _buildManualStepInput(
                                  context, stepCount.date);
                            }
                            return ListTile(
                              title: Text(
                                DateFormat('yyyy년 MM월 dd일')
                                    .format(stepCount.date),
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                              trailing: Text(
                                '${formatSteps(stepCount.steps)} 걸음',
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
                        SizedBox(height: 60),
                        if (controller.predictedStepsData != null &&
                            controller.predictedStepsData!.error == null)
                          Builder(builder: (context) {
                            final data = controller.predictedStepsData!;
                            final wasteGradeEnum =
                            waistRiskFromString(data.waistRisk);
                            final emojiAssetPath =
                            getEmojiAssetForWaistRisk(wasteGradeEnum);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _healthTitle(
                                  title: 'AI가 알려주는 다음 주의 나',
                                  content:
                                  '다음 주의 내 걸음 수는\n이렇게 예상되어요',
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 148,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: AppColors.dialogBackgroundColor,
                                        borderRadius:
                                        BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '예측걸음',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color:
                                              AppColors.primaryTextColor,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            formatSteps(data.predictedSteps),
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 36,
                                              color: AppColors.titleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 148,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: AppColors.dialogBackgroundColor,
                                        borderRadius:
                                        BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '도전 목표 걸음',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${formatSteps(data.challengeGoal)}',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 36,
                                              color: AppColors.titleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 60),
                                _healthTitle(
                                  title: '나의 건강 알아보기',
                                  content:
                                  'AI가 분석한 신체 정보를 기반으로\n나와 같은 그룹을 확인할 수 있어요',
                                ),
                                SizedBox(height: 32),
                                _buildUserInfoContainer(data),
                                SizedBox(height: 36),
                                _buildObesityRiskContainer(data, emojiAssetPath),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '**제2형 당뇨병, 고혈압, 고지혈증, 관상동맥질환 및 대사증후군 등',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color:
                                              AppColors.hintTextColor,
                                            ),
                                          ),
                                          Text(
                                            '출처: 대한비만학회',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color:
                                              AppColors.hintTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 42),
                                _healthTitle(
                                  title: '맞춤형 칼로리 계산',
                                  content:
                                  '지금 체중으로 얼마나 달려야 할까?',
                                ),
                                SizedBox(height: 36),
                                _buildCalorieContainer(data),
                                SizedBox(height: 60),
                                _healthTitle(
                                  title:
                                  '나를 위한 운동 처방 동영상 추천',
                                  content:
                                  '어떤 운동부터 하면 좋을지 고민 되시나요?\n국민체력100에서 추천하는 운동 처방에 따라 시작해봐요',
                                ),
                              ],
                            );
                          })
                        else
                          SizedBox.shrink(),
                        SizedBox(height: 16),
                        _buildCustomButton(
                          context,
                          labelTop: '운동 동영상 보기',
                          labelBottom:
                          '등록한 신체 정보를 바탕으로 추천해드려요',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HealthVideoInfoPage(),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                if (controller.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
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

    stepData.sort((a, b) => a.date.compareTo(b.date));
    List<String> xLabels =
    stepData.map((e) => DateFormat('MM/dd').format(e.date)).toList();

    List<FlSpot> spots = [];
    for (int i = 0; i < stepData.length; i++) {
      spots.add(FlSpot(i.toDouble(), stepData[i].steps.toDouble()));
    }

    double maxY = stepData
        .map((e) => e.steps)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    maxY = (maxY + 1000);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            maxY: maxY,
            minY: 0,
            backgroundColor: AppColors.backgroundColor,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
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
                ),
                dotData: FlDotData(show: true),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => AppColors.inactiveButtonColor,
                tooltipRoundedRadius: 8,
                tooltipPadding: EdgeInsets.all(12),
                tooltipMargin: 32,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
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
