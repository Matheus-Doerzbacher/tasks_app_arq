class ExceptionMessage {
  static String message(String exception) {
    return exception.replaceAll('Exception: ', '');
  }
}
