class PredictedStepsData {
  final int? ageGroup;
  final String? gender;
  final int? predictedSteps;
  final int? challengeGoal;
  final int? comparisonFlag;
  final int? difference;
  final int? userAvg;
  final int? groupAvg;
  final double? bmi;
  final String? bmiGrade;
  final String? waistRisk;
  final int? slowWalkCal;
  final int? normalWalkCal;
  final int? fastWalkCal;
  final String? error;

  PredictedStepsData({
    this.ageGroup,
    this.gender,
    this.predictedSteps,
    this.challengeGoal,
    this.comparisonFlag,
    this.difference,
    this.userAvg,
    this.groupAvg,
    this.bmi,
    this.bmiGrade,
    this.waistRisk,
    this.slowWalkCal,
    this.normalWalkCal,
    this.fastWalkCal,
    this.error,
  });

  factory PredictedStepsData.fromJson(Map<String, dynamic> json) {
    return PredictedStepsData(
      ageGroup: json['age_group'],
      gender: json['gender'],
      predictedSteps: json['predicted_steps'],
      challengeGoal: json['challenge_goal'],
      comparisonFlag: json['comparison_flag'],
      difference: json['difference'],
      userAvg: json['user_avg'],
      groupAvg: json['group_avg'],
      bmi: (json['bmi'] as num?)?.toDouble(),
      bmiGrade: json['bmi_grade'],
      waistRisk: json['waist_risk'],
      slowWalkCal: json['slow_walk_cal'],
      normalWalkCal: json['normal_walk_cal'],
      fastWalkCal: json['fast_walk_cal'],
      error: json['error'],
    );
  }
}