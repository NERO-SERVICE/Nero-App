enum StepType {
  init(''),
  dataload('데이터 로드'),
  authCheck('인증 체크');

  const StepType(this.name);
  final String name;
}