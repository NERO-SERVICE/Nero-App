enum AuthenticationStatus {
  authentication, // 로그인 완료 상태
  unAuthenticated, // Firebase SNS 로그인은 되었지만, 내부 서비스 DB에 가입 이력이 없어 회원 가입이 필요한 상태
  unknown, // 비로그인 상태
  init, // 초기화 상태
}