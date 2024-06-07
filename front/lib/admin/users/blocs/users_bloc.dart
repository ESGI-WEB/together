import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/conflit_exception.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/event_type_services.dart';
import 'package:front/core/services/user_services.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersState()) {
    on<UsersDataTableLoaded>((event, emit) async {
      emit(state.copyWith(
        status: UsersStatus.tableLoading,
      ));

      try {
        final usersPage = await UserServices.getUsers(
          page: event.page,
          search: event.search,
        );
        var allUsers = state.users;
        if (usersPage.page > 1) {
          allUsers.addAll(usersPage.rows);
        } else {
          allUsers = usersPage.rows;
        }

        emit(state.copyWith(
          status: UsersStatus.tableSuccess,
          users: allUsers,
          pages: usersPage.pages,
          lastPage: usersPage.page,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: UsersStatus.tableError,
          errorMessage: error.message,
        ));
      }
    });
  }
}
