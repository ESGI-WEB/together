part of 'create_publication_bloc.dart';

@immutable
abstract class CreatePublicationEvent {}

class CreatePublicationSubmitted extends CreatePublicationEvent {
  final Map<String, dynamic> newPublication;

  CreatePublicationSubmitted(this.newPublication);
}