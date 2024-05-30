import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/group_bloc.dart';

class GroupScreen extends StatelessWidget {
  final int id;

  const GroupScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc()..add(LoadGroup(id)),
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupLoadSingleSuccess) {
            final group = state.group;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(group.name),
                  const SizedBox(height: 10),
                  Text(group.description ?? ''),
                ],
              ),
            );
          } else if (state is GroupsLoadError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
