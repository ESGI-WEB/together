class UnauthorizedException extends Error {
  final String message;

  UnauthorizedException({this.message = 'Accès non autorisé'});
}
