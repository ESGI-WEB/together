import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/services/message_services.dart';
import 'package:front/core/models/message.dart';

part 'publications_event.dart';
part 'publications_state.dart';

class PublicationsBloc extends Bloc<PublicationsEvent, PublicationsState> {
  PublicationsBloc() : super(PublicationsState()) {
    on<LoadPublications>((event, emit) async {
      emit(state.copyWith(
        status: PublicationsStatus.loading,
        page: 1,
        hasReachedMax: false,
      ));

      try {
        final paginatedPublications = await MessageServices.fetchPublicationsByGroup(event.groupId, state.page, state.limit, );
        emit(state.copyWith(
          status: PublicationsStatus.success,
          publications: paginatedPublications.rows,
          total: paginatedPublications.total,
          pages: paginatedPublications.pages,
          hasReachedMax: paginatedPublications.page >= paginatedPublications.pages,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PublicationsStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<PublicationsLoadMore>((event, emit) async {
      if (state.hasReachedMax || state.status == PublicationsStatus.loadingMore) return;

      try {
        emit(state.copyWith(status: PublicationsStatus.loadingMore));
        final newPage = state.page + 1;
        final paginatedPublications = await MessageServices.fetchPublicationsByGroup(event.groupId, newPage, state.limit);
        final updatedPublications = List<Message>.from(state.publications ?? [])..addAll(paginatedPublications.rows);
        emit(state.copyWith(
          status: PublicationsStatus.success,
          publications: updatedPublications,
          page: newPage,
          hasReachedMax: newPage >= paginatedPublications.pages,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PublicationsStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<PublicationAdded>((event, emit) {
      final updatedPublications = List<Message>.from(state.publications ?? [])..add(event.publication);
      emit(state.copyWith(
        publications: updatedPublications,
        status: PublicationsStatus.success,
      ));
    });

    on<UpdatePublication>((event, emit) async {
      try {
        final updatedMessage = await MessageServices.updateMessage(event.id, {
          'content': event.publication.content,
        });

        final updatedPublications = state.publications!.map((publication) {
          return publication.id == updatedMessage.id ? updatedMessage : publication;
        }).toList();

        emit(state.copyWith(
          publications: updatedPublications,
          status: PublicationsStatus.success,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PublicationsStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}