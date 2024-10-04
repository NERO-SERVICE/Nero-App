class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException([this.message = '사용자를 찾을 수 없습니다.']);

  @override
  String toString() => 'UserNotFoundException: $message';
}