import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_car_app/components/my_text_field.dart';
import 'package:rental_car_app/components/password_validation_check_list.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            setState(() {
              signUpRequired = false;
            });
          } else if (state is SignUpLoading) {
            setState(() {
              signUpRequired = true;
            });
          } else if (state is SignUpFailure) {
            // Handle failure state
          }
        },
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.mail),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          iconPassword = obscurePassword
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash_fill;
                        });
                      },
                      icon: Icon(iconPassword),
                    ),
                    onChanged: (val) {
                      setState(() {
                        containsUpperCase = val!.contains(RegExp(r'[A-Z]'));
                        containsLowerCase = val.contains(RegExp(r'[a-z]'));
                        containsNumber = val.contains(RegExp(r'[0-9]'));
                        containsSpecialChar = val.contains(
                            RegExp(r'[!@#\$&*~`%\-_=+;:,.<>?{}\[\]|^]'));
                        contains8Length = val.length >= 8;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your password';
                      } else if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(val)) {
                        return 'Password too weak';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  PasswordValidationChecklist(
                    containsUpperCase: containsUpperCase,
                    containsLowerCase: containsLowerCase,
                    containsNumber: containsNumber,
                    containsSpecialChar: containsSpecialChar,
                    contains8Length: contains8Length,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: nameController,
                    hintText: 'Full Name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(CupertinoIcons.person),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your name';
                      } else if (val.length > 30) {
                        return 'Name is too long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  signUpRequired
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              MyUser myUser = MyUser.empty;
                              myUser.email = emailController.text;
                              myUser.name = nameController.text;

                              context.read<SignUpBloc>().add(SignUpRequired(
                                    myUser,
                                    passwordController.text,
                                  ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
