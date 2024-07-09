import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/models/poll_choice.dart';
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

        await PollServices.getPollById(id: event.pollId);

        emit(state.copyWith(
          status: PollStatus.pollChoiceSaved,
        ));
      } on ApiException catch (error) {
        emit(
          state.copyWith(
            status: PollStatus.pollChoiceSaveError,
            errorMessage: error.message,
          ),
        );
      }
    });

    on<PollCreatedOrEdited>((event, emit) async {
      emit(state.copyWith(status: PollStatus.creatingPoll));

      try {
        if (event.poll.id != null) {
          await PollServices.updatePoll(
            id: event.poll.id!,
            data: event.poll.toJson(),
          );
        } else {
          await PollServices.createPoll(
            poll: event.poll,
          );
        }

        emit(state.copyWith(status: PollStatus.pollCreated));
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
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.closePollError,
          errorMessage: error.message,
        ));
      }
    });

    on<ChoiceAdded>((event, emit) async {
      emit(state.copyWith(status: PollStatus.addingChoice));

      try {
        var pollToEdit = event.poll.toCreateOrEdit();

        pollToEdit.choices!.add(event.choice);

        await PollServices.updatePoll(
          id: event.poll.id,
          data: pollToEdit.toJson(),
        );

        emit(state.copyWith(status: PollStatus.choiceAdded));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.addChoiceError,
          errorMessage: error.message,
        ));
      }
    });
  }
}
