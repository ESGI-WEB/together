import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/models/user.dart';
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
        );

        final userData = await StorageService.readJwtDataFromToken();

        emit(state.copyWith(
          status: PollStatus.success,
          pollPage: pollPage,
          userData: userData,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: PollStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    // on<PollUpdated>((event, emit) async {
    //   emit(state.copyWith(status: PollStatus.gettingPoll));
    //
    //   try {
    //     final pollUpdated = await PollServices.getPollById(id: event.id);
    //
    //     emit(state.copyWith(
    //       status: PollStatus.gotPoll,
    //       pollUpdated: pollUpdated,
    //     ));
    //   } on ApiException catch (error) {
    //     emit(state.copyWith(
    //       status: PollStatus.getPollError,
    //       errorMessage: error.message,
    //     ));
    //   }
    // });

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
          errorMessage: error.message
        ));
      }
    });
  }

}
