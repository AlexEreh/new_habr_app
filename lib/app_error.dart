enum ErrorType {
  badRequest,
  badResponse,
  serverError,
  notFound,
  notCached,
}

class AppError {
  final ErrorType errCode;
  final String? message;

  const AppError({
    required this.errCode,
    this.message,
  });

  @override
  String toString() {
    if (message == null || message!.isEmpty) {
      return errCode.toString();
    }
    return "$errCode: $message";
  }
}
