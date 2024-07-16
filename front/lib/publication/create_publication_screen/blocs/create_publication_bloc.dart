import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/services/message_services.dart';
part 'create_publication_event.dart';
part 'create_publication_state.dart';

class CreatePublicationBloc extends Bloc<CreatePublicationEvent, CreatePublicationState> {
  CreatePublicationBloc() : super(CreatePublicationState()) {
    on<CreatePublicationSubmitted>((event, emit) async {
      emit(state.copyWith(status: CreatePublicationStatus.loading));

      try {
        final newPublication = await MessageServices.createPublication(event.newPublication);
        emit(state.copyWith(
          status: CreatePublicationStatus.success,
          newPublication: newPublication,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: CreatePublicationStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}