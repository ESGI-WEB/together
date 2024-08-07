import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/services/message_services.dart';

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
        final paginatedPublications =
            await MessageServices.fetchPublicationsByGroup(
          event.groupId,
          state.page,
          state.limit,
        );
        emit(state.copyWith(
          status: PublicationsStatus.success,
          publications: paginatedPublications.rows,
          total: paginatedPublications.total,
          pages: paginatedPublications.pages,
          hasReachedMax:
              paginatedPublications.page >= paginatedPublications.pages,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PublicationsStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<PublicationsLoadMore>((event, emit) async {
      if (state.hasReachedMax ||
          state.status == PublicationsStatus.loadingMore) {
        return;
      }

      try {
        emit(state.copyWith(status: PublicationsStatus.loadingMore));
        final newPage = state.page + 1;
        final paginatedPublications =
            await MessageServices.fetchPublicationsByGroup(
                event.groupId, newPage, state.limit);
        final updatedPublications = List<Message>.from(state.publications ?? [])
          ..addAll(paginatedPublications.rows);
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
      final updatedPublications = List<Message>.from(state.publications ?? []);

      if (event.publication.isPinned) {
        updatedPublications.insert(0, event.publication);
      } else {
        int lastPinnedIndex =
            updatedPublications.indexWhere((pub) => !pub.isPinned);
        if (lastPinnedIndex == -1) {
          updatedPublications.add(event.publication);
        } else {
          updatedPublications.insert(lastPinnedIndex, event.publication);
        }
      }

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
          return publication.id == updatedMessage.id
              ? updatedMessage
              : publication;
        }).toList();

        updatedPublications.sort((a, b) {
          if (a.isPinned && !b.isPinned) {
            return -1;
          } else if (!a.isPinned && b.isPinned) {
            return 1;
          } else if (a.id == updatedMessage.id) {
            return -1;
          } else if (b.id == updatedMessage.id) {
            return 1;
          }
          return 0;
        });

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

    on<PinPublication>((event, emit) async {
      try {
        final pinnedMessage = await MessageServices.pinMessage(
            event.id, {'is_pinned': event.isPinned.isPinned});

        final updatedPublications =
            List<Message>.from(state.publications ?? []);
        final publicationIndex = updatedPublications
            .indexWhere((publication) => publication.id == pinnedMessage.id);

        if (publicationIndex != -1) {
          updatedPublications.removeAt(publicationIndex);
        }

        if (pinnedMessage.isPinned) {
          updatedPublications.insert(0, pinnedMessage);
        } else {
          int lastPinnedIndex =
              updatedPublications.lastIndexWhere((pub) => pub.isPinned);
          updatedPublications.insert(lastPinnedIndex + 1, pinnedMessage);
        }

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
