import 'package:meta/meta.dart';

@immutable
abstract class CreatePublicationEvent {}

class CreatePublicationSubmitted extends CreatePublicationEvent {
  final Map<String, dynamic> newPublication;

  CreatePublicationSubmitted(this.newPublication);
}