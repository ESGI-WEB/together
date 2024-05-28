class ConflictException extends Error {
  final String message;

  ConflictException({this.message = 'Conflit'});
}
