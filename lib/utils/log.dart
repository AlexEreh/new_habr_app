import 'package:flutter/foundation.dart';

void logError(Object e, [StackTrace? stackTrace]) {
  if (kDebugMode) {
    print(e.toString());
  }
  if (stackTrace != null) print(stackTrace);
}

void logInfo(Object obj) {
  if (kDebugMode) {
    print(obj);
  }
}