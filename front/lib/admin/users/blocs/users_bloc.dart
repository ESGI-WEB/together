import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/user_services.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersState()) {
    on<UsersDataTableLoaded>((event, emit) async {
      emit(state.copyWith(
        status: UsersStatus.tableLoading,
        search: event.search ?? state.search,
      ));

      try {
        final usersPage = await UserServices.getUsers(
          page: event.page,
          search: state.search,
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

    on<UserCreatedOrEdited>((event, emit) async {
      emit(state.copyWith(status: UsersStatus.formLoading));

      try {
        if (event.id == null) {
          await UserServices.registerAsAdmin(event.user);
        } else {
          await UserServices.editUser(event.id!, event.user);
        }
        emit(state.copyWith(
          status: UsersStatus.formSuccess,
        ));

        add(UsersDataTableLoaded());
      } catch (error) {
        final String defaultErrorMessage = event.id == null
            ? "Impossible de créer l'utilisateur."
            : "Impossible de modifier l'utilisateur.";
        emit(state.copyWith(
          status: UsersStatus.formError,
          formErrorMessage: error is ApiException && error.message.isNotEmpty
              ? error.message
              : defaultErrorMessage,
        ));
      }
    });
  }
}
