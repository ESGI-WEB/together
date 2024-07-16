import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/login/login_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                        Text(AppLocalizations.of(context)!.register,
                            style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 10),
                        if (state is RegisterError)
                          Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        TextFormField(
                          enabled: state is! RegisterLoading,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.name,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.nameRequired;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            BlocProvider.of<RegisterBloc>(context).add(
                                RegisterFormChanged(
                                    name: value,
                                    email: state.email,
                                    password: state.password,
                                ));
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: state is! RegisterLoading,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.email,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.emailRequired;
                            }
                            if (!UserServices.emailRegex.hasMatch(value)) {
                              return AppLocalizations.of(context)!.emailInvalid;
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
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.password,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.passwordRequired;
                            }

                            if (value.length < 8) {
                              return AppLocalizations.of(context)!.passwordTooShort(8);
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
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.confirmPassword,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return  AppLocalizations.of(context)!.passwordRequired;
                            }

                            if (value != state.password) {
                              return  AppLocalizations.of(context)!.passwordsDoNotMatch;
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
                                child: Text(AppLocalizations.of(context)!.register),
                              ),
                              TextButton(
                                onPressed: () {
                                  LoginScreen.navigateTo(context);
                                },
                                child: Text(AppLocalizations.of(context)!.login),
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
