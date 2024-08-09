enum DrfStepType{
  init(''),
  dataLoad('데이터 로드'),
  authCheck('인증 체크');

  const DrfStepType(this.name);
  final String name;
}