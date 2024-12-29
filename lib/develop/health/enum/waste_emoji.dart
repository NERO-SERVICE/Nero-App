enum WaistRisk {
  low,              // 낮음
  normal,           // 보통
  slightlyHigh,     // 약간높음
  high,             // 높음
  veryHigh,         // 매우높음
  highest,          // 가장높음
}

WaistRisk? waistRiskFromString(String? risk) {
  if (risk == null) return null;
  switch (risk) {
    case '낮음':
      return WaistRisk.low;
    case '보통':
      return WaistRisk.normal;
    case '약간 높음':
      return WaistRisk.slightlyHigh;
    case '높음':
      return WaistRisk.high;
    case '매우 높음':
      return WaistRisk.veryHigh;
    case '가장 높음':
      return WaistRisk.highest;
    default:
      return null;
  }
}

String getEmojiAssetForWaistRisk(WaistRisk? risk) {
  // 1: 낮음, 2: 보통, 3: 약간높음, 4: 높음, 5: 매우높음, 6: 가장높음
  if (risk == null) {
    // 기본값
    return 'assets/develop/emoji/emotional_stage_1.png';
  }

  switch (risk) {
    case WaistRisk.low:
      return 'assets/develop/emoji/emotional_stage_1.png';
    case WaistRisk.normal:
      return 'assets/develop/emoji/emotional_stage_2.png';
    case WaistRisk.slightlyHigh:
      return 'assets/develop/emoji/emotional_stage_3.png';
    case WaistRisk.high:
      return 'assets/develop/emoji/emotional_stage_4.png';
    case WaistRisk.veryHigh:
      return 'assets/develop/emoji/emotional_stage_5.png';
    case WaistRisk.highest:
      return 'assets/develop/emoji/emotional_stage_6.png';
  }
}