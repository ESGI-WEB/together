import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/user.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:front/publications/partials/PublicationsListItem.dart';

class PublicationsList extends StatelessWidget {
  final int groupId;
  final User? authenticatedUser;

  const PublicationsList({
    super.key,
    required this.groupId,
    this.authenticatedUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicationsBloc, PublicationsState>(
      builder: (context, state) {
        if (state.status == PublicationsStatus.loading &&
            state.publications == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == PublicationsStatus.error) {
          return Center(
              child: Text(state.errorMessage ?? 'Erreur inconnue'));
        }

        final publications = state.publications;
        if (publications == null || publications.isEmpty) {
          return const Center(child: Text('Aucune publication disponible'));
        }

        return Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent &&
                  !state.hasReachedMax) {
                context
                    .read<PublicationsBloc>()
                    .add(PublicationsLoadMore(groupId));
              }
              return false;
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: publications.length +
                  (state.status == PublicationsStatus.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == publications.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final publication = publications[index];
                  return PublicationsListItem(
                    publication: publication,
                    authenticatedUser: authenticatedUser,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
