import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:go_router/go_router.dart';

import 'blocs/join_group_bloc.dart';

class JoinGroupScreen extends StatelessWidget {
  static const String routeName = 'join_group';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JoinGroupBloc(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<JoinGroupBloc, JoinGroupState>(
            builder: (context, state) {
              if (state.status == JoinGroupStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == JoinGroupStatus.error) {
                return Center(
                  child: ErrorOccurred(
                    image: SvgPicture.asset(
                      'assets/images/error.svg',
                      height: 200,
                    ),
                    alertMessage: 'Failed to join group',
                    bodyMessage: state.errorMessage ?? 'Failed to join group',

                  ),
                );
              }

              if (state.status == JoinGroupStatus.success && state.newGroup?.id != null) {
                GroupScreen.navigateTo(context, id: state.newGroup!.id);
              }

              return JoinGroupForm();
            },
          ),
        ),
      ),
    );
  }
}

class JoinGroupForm extends StatefulWidget {
  @override
  _JoinGroupFormState createState() => _JoinGroupFormState();
}

class _JoinGroupFormState extends State<JoinGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: 'Code du groupe'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                BlocProvider.of<JoinGroupBloc>(context).add(
                  JoinGroupSubmitted({
                    'code': _codeController.text,
                  }),
                );
              }
            },
            child: const Text('Rejoindre'),
          ),
        ],
      ),
    );
  }
}