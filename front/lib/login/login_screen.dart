import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/groups_list_screen.dart';
import 'package:front/login/blocs/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';
  static Future<void> navigateTo(BuildContext context, {bool removeHistory = false}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => !removeHistory);
  }

  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              GroupsListScreen.navigateTo(context, removeHistory: true);
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            return Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Se connecter',
                          style: Theme.of(context).textTheme.displayLarge),
                      const SizedBox(height: 10),
                      if (state is LoginError)
                        Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      TextFormField(
                        enabled: state is! LoginLoading,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (value) {
                          BlocProvider.of<LoginBloc>(context)
                              .add(LoginEmailChanged(email: value));
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un email';
                          }

                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Veuillez saisir un email valide';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: state is! LoginLoading,
                        decoration: const InputDecoration(
                          hintText: 'Mot de passe',
                        ),
                        onChanged: (value) {
                          BlocProvider.of<LoginBloc>(context)
                              .add(LoginPasswordChanged(password: value));
                        },
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un mot de passe';
                          }

                          if (value.length < 8) {
                            return 'Ajouter au moins 8 caractères';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Builder(builder: (context) {
                        if (state is LoginLoading) {
                          return const CircularProgressIndicator();
                        }

                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<LoginBloc>(context)
                                  .add(LoginFormSubmitted());
                            }
                          },
                          child: const Text('Connexion'),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
