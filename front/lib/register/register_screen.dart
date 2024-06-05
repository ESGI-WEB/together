import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/login/login_screen.dart';
import 'package:go_router/go_router.dart';

import 'blocs/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc()..add(RegisterAvailabilityChecked()),
      child: Scaffold(
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              LoginScreen.navigateTo(context, email: state.user.email);
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
            if (state is RegisterFeatureDisabled) {
              return ErrorOccurred(
                    image: SvgPicture.asset(
                      'assets/images/503.svg',
                      height: 200,
                    ),
                  );
            }

            return Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/talks.svg',
                          width: 150,
                        ),
                        const SizedBox(height: 10),
                        Text("S'inscrire",
                            style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 10),
                        if (state is RegisterError)
                          Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        TextFormField(
                          enabled: state is! RegisterLoading,
                          decoration: const InputDecoration(
                            hintText: 'Nom',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            BlocProvider.of<RegisterBloc>(context).add(
                                RegisterFormChanged(
                                    name: value,
                                    email: state.email,
                                    password: state.password));
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: state is! RegisterLoading,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un email';
                            }
                            if (!UserServices.emailRegex.hasMatch(value)) {
                              return 'Veuillez saisir un email valide';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            BlocProvider.of<RegisterBloc>(context).add(
                                RegisterFormChanged(
                                    email: value,
                                    name: state.name,
                                    password: state.password));
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: state is! RegisterLoading,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Mot de passe',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un mot de passe';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            BlocProvider.of<RegisterBloc>(context).add(
                                RegisterFormChanged(
                                    password: value,
                                    name: state.name,
                                    email: state.email));
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: state is! RegisterLoading,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Confirmer le mot de passe',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un mot de passe';
                            }

                            if (value != state.password) {
                              return 'Les mots de passe ne correspondent pas';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        Builder(builder: (context) {
                          if (state is RegisterLoading) {
                            return const CircularProgressIndicator();
                          }

                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<RegisterBloc>(context)
                                        .add(RegisterFormSubmitted());
                                  }
                                },
                                child: const Text('Inscription'),
                              ),
                              TextButton(
                                onPressed: () {
                                  LoginScreen.navigateTo(context);
                                },
                                child: const Text('Se connecter'),
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
