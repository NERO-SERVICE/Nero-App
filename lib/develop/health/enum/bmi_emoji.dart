enum BMIGrade {
  underweight,      // 저체중
  normal,           // 정상
  overweight,       // 비만전단계비만
  obese1,           // 1단계비만
  obese2,           // 2단계비만
  obese3,           // 3단계비만
}

BMIGrade? bmiGradeFromString(String? grade) {
  if (grade == null) return null;
  switch (grade) {
    case '저체중':
      return BMIGrade.underweight;
    case '정상':
      return BMIGrade.normal;
    case '비만전단계비만':
      return BMIGrade.overweight;
    case '1단계비만':
      return BMIGrade.obese1;
    case '2단계비만':
      return BMIGrade.obese2;
    case '3단계비만':
      return BMIGrade.obese3;
    default:
      return null;
  }
}

String getEmojiAssetForBmiGrade(BMIGrade? grade) {
  // 1: 저체중, 2: 정상, 3: 비만전단계비만, 4: 1단계비만, 5: 2단계비만, 6: 3단계비만
  if (grade == null) {
    // 기본값
    return 'assets/develop/emoji/emotional_stage_1.png';
  }

  switch (grade) {
    case BMIGrade.underweight:
      return 'assets/develop/emoji/emotional_stage_1.png';
    case BMIGrade.normal:
      return 'assets/develop/emoji/emotional_stage_2.png';
    case BMIGrade.overweight:
      return 'assets/develop/emoji/emotional_stage_3.png';
    case BMIGrade.obese1:
      return 'assets/develop/emoji/emotional_stage_4.png';
    case BMIGrade.obese2:
      return 'assets/develop/emoji/emotional_stage_5.png';
    case BMIGrade.obese3:
      return 'assets/develop/emoji/emotional_stage_6.png';
  }
}
