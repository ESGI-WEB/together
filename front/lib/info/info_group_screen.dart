import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/groups/group_screen/blocs/group_bloc.dart';
import 'package:go_router/go_router.dart';

class InfoGroupScreen extends StatelessWidget {
  static const String routeName = 'info-group';

  final int groupId;

  const InfoGroupScreen({super.key, required this.groupId});

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(
      routeName,
      pathParameters: {'groupId': id.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc()..add(LoadGroup(groupId: groupId)),
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state.status == GroupStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == GroupStatus.success) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.group?.code,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.groupCode,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: state.group!.code));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(AppLocalizations.of(context)!.copiedCode),
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state.status == GroupStatus.error) {
            return Center(
              child: Text(state.errorMessage ??
                  AppLocalizations.of(context)!.errorOccurred),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
