import 'package:front/core/models/message.dart';

enum CreatePublicationStatus {
  initial,
  loading,
  success,
  error,
}

class CreatePublicationState {
  final CreatePublicationStatus status;
  final Message? newPublication;
  final String? errorMessage;

  CreatePublicationState({
    this.status = CreatePublicationStatus.initial,
    this.newPublication,
    this.errorMessage,
  });

  CreatePublicationState copyWith({
    CreatePublicationStatus? status,
    Message? newPublication,
    String? errorMessage,
  }) {
    return CreatePublicationState(
      status: status ?? this.status,
      newPublication: newPublication ?? this.newPublication,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}