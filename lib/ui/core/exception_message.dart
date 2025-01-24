class ExceptionMessage {
  static String message(String exception) {
    switch (exception) {
      // LOGIN
      case 'Exception: User not found':
        return 'Usuário não encontrado';
      // DEFAULT
      default:
        return 'Falha ao criar usuário';
    }
  }
}
