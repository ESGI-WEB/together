import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/groups/groups_screen/groups_screen.dart';
import 'package:front/login/blocs/login_bloc.dart';
import 'package:front/register/register_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login';

  static void navigateTo(
    BuildContext context, {
    String? email,
  }) {
    context.goNamed(routeName, queryParameters: {'email': email});
  }

  final String? defaultEmail;

  LoginScreen({
    super.key,
    this.defaultEmail,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              GroupsScreen.navigateTo(context);
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            if (defaultEmail != null) {
              _emailController.text = defaultEmail!;
              BlocProvider.of<LoginBloc>(context)
                  .add(LoginEmailChanged(email: defaultEmail!));
            }

            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ClipOval(
                          child: Image(
                            image: AssetImage('assets/images/login.gif'),
                            width: 150,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.helloWorld,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 10),
                        if (state is LoginError)
                          Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        TextFormField(
                          enabled: state is! LoginLoading,
                          controller: _emailController,
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

                            if (!UserServices.emailRegex.hasMatch(value)) {
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
                        const SizedBox(height: 30),
                        Builder(builder: (context) {
                          if (state is LoginLoading) {
                            return const CircularProgressIndicator();
                          }

                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(LoginFormSubmitted());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Connexion'),
                              ),
                              TextButton(
                                onPressed: () {
                                  RegisterScreen.navigateTo(context);
                                },
                                child: const Text('Inscription'),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
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
