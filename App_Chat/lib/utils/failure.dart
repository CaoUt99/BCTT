abstract class Failure {
  String code;
}

abstract class BottomPlacedException extends Failure {}

class UnImplementedFailure extends BottomPlacedException {
  final code = "Đã xảy ra lỗi!";
}

class NetworkException extends BottomPlacedException {
  final code = "Lỗi kết nối mạng !";
}

abstract class AuthException extends Failure {}

abstract class PasswordException extends AuthException {}

abstract class EmailException extends AuthException {}

class WeakPasswordException extends PasswordException {
  final code = "mật khẩu phải có ít nhất 6 ký tự.";
}

class WrongPasswordException extends PasswordException {
  final code = "Mật khẩu của bạn sai.";
}

class InvalidEmailException extends EmailException {
  final code = "Địa chỉ email của bạn không hợp lệ.";
}

class NotFoundEmailException extends EmailException {
  final code = "Người dùng có email này không tồn tại.";
}

class EmailInUseException extends EmailException {
  final code = "Email đã được sử dụng";
}

class NoUserSignedInException extends AuthException {
  final code = "Không có người dùng nào đăng nhập";
}

class NoException extends Failure {}
