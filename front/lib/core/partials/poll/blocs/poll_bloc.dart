import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/services/poll_services.dart';
import 'package:front/core/services/storage_service.dart';

part 'poll_event.dart';

part 'poll_state.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  PollBloc() : super(PollState()) {
    on<PollNextPageLoaded>((event, emit) async {
      emit(state.copyWith(status: PollStatus.loading));

      try {
        final pollPage = await PollServices.get(
          page: event.page,
          id: event.id,
          type: event.type,
        );

        final userData = await StorageService.readJwtDataFromToken();

        emit(state.copyWith(
          status: PollStatus.success,
          pollPage: pollPage,
          userData: userData,
          id: event.id,
          type: event.type,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<ClosedPollNextPageLoaded>((event, emit) async {
      emit(state.copyWith(status: PollStatus.loadingClosedPolls));

      try {
        final pollPage = await PollServices.get(
          page: event.page,
          id: event.id,
          type: event.type,
          closed: true,
        );

        final userData = await StorageService.readJwtDataFromToken();

        emit(state.copyWith(
          status: PollStatus.closedPollsSuccess,
          pollPage: pollPage,
          userData: userData,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.loadClosedPollsError,
          errorMessage: error.message,
        ));
      }
    });

    on<PollChoiceSaved>((event, emit) async {
      emit(state.copyWith(status: PollStatus.savingPollChoice));

      try {
        if (event.selected) {
          await PollServices.saveChoice(
            pollId: event.pollId,
            choiceId: event.choiceId,
          );
        } else {
          await PollServices.deleteChoice(
            pollId: event.pollId,
            choiceId: event.choiceId,
          );
        }

        final poll = await PollServices.getPollById(id: event.pollId);

        emit(state.copyWith(
          status: PollStatus.pollChoiceSaved,
          pollUpdated: poll,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
            status: PollStatus.pollChoiceSaveError,
            errorMessage: error.message));
      }
    });

    on<PollCreated>((event, emit) async {
      emit(state.copyWith(status: PollStatus.creatingPoll));

      try {
        await PollServices.createPoll(
          poll: event.poll,
        );

        emit(state.copyWith(status: PollStatus.pollCreated));

        if (state.id != null && state.type != null) {
          // on refresh la liste des sondages
          add(PollNextPageLoaded(
            id: state.id!,
            type: state.type!,
          ));
        }
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.createPollError,
          errorMessage: error.message,
        ));
      }
    });

    on<PollDeleted>((event, emit) async {
      emit(state.copyWith(status: PollStatus.deletingPoll));

      try {
        await PollServices.deletePoll(
          id: event.id,
        );

        emit(state.copyWith(status: PollStatus.pollDeleted));

        if (state.id != null && state.type != null) {
          // on refresh la liste des sondages
          add(PollNextPageLoaded(
            id: state.id!,
            type: state.type!,
          ));
        }
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.deletePollError,
          errorMessage: error.message,
        ));
      }
    });

    on<PollClosed>((event, emit) async {
      emit(state.copyWith(status: PollStatus.closingPoll));

      try {
        await PollServices.updatePoll(id: event.id, data: {
          "is_closed": true,
        });

        emit(state.copyWith(status: PollStatus.pollClosed));

        if (state.id != null && state.type != null) {
          // on refresh la liste des sondages
          add(PollNextPageLoaded(
            id: state.id!,
            type: state.type!,
          ));
        }
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.closePollError,
          errorMessage: error.message,
        ));
      }
    });
  }
}
