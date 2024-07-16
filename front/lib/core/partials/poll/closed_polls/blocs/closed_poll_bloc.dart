import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';
import 'package:front/core/services/poll_services.dart';
import 'package:front/core/services/storage_service.dart';

part 'closed_poll_event.dart';

part 'closed_poll_state.dart';

class ClosedPollBloc extends Bloc<ClosedPollEvent, ClosedPollState> {
  ClosedPollBloc() : super(ClosedPollState()) {
    on<ClosedPollNextPageLoaded>((event, emit) async {
      emit(state.copyWith(status: ClosedPollStatus.loadingClosedPolls));

      try {
        final pollPage = await PollServices.get(
          page: event.page,
          id: event.id,
          type: event.type,
          closed: true,
        );

        final userData = await StorageService.readJwtDataFromToken();

        emit(state.copyWith(
          status: ClosedPollStatus.closedPollsSuccess,
          pollPage: pollPage,
          userData: userData,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: ClosedPollStatus.loadClosedPollsError,
          errorMessage: error.message,
        ));
      }
    });
  }
}
