import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/services/group_services.dart';

part 'last_groups_list_event.dart';

part 'last_groups_list_state.dart';

class LastGroupsListBloc
    extends Bloc<LastGroupsListEvent, LastGroupsListState> {
  LastGroupsListBloc() : super(LastGroupsListState()) {
    on<LastGroupsListLoaded>((event, emit) async {
      emit(state.copyWith(
        status: LastGroupsListStatus.loading,
      ));

      try {
        final groupsPage = await GroupServices.getAllGroups(
          sort: 'created_at desc',
          limit: 10,
        );
        emit(state.copyWith(
          status: LastGroupsListStatus.success,
          groupsPage: groupsPage,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: LastGroupsListStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
