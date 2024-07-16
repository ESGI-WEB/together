import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/user.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:front/publications/partials/PublicationsListItem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PublicationsList extends StatelessWidget {
  final int groupId;
  final User? authenticatedUser;
  final PublicationsBloc publicationsBloc;
  final Function()? onAddPublication;

  const PublicationsList({
    super.key,
    required this.groupId,
    this.authenticatedUser,
    required this.publicationsBloc,
    this.onAddPublication,
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
              child: Text(state.errorMessage ??
                  AppLocalizations.of(context)!.errorOccurred));
        }

        final publications = state.publications;
        if (publications == null || publications.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.publications,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  if (onAddPublication != null)
                    IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: onAddPublication,
                      icon: const Icon(Icons.add),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            NotificationListener<ScrollNotification>(
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
              child: Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
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
                        publicationsBloc: context.read<PublicationsBloc>(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
