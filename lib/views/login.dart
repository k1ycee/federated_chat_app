import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matrix_project/core/services/matrix_service.dart';
import 'package:matrix_project/core/services/navigation_service.dart';
import 'package:matrix_project/core/utils/extension/extensions.dart';
import 'package:matrix_project/views/chats.dart';
import 'package:matrix_project/widgets/textfield_widget.dart';

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isValidEmail = false;
  bool isValidPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(70),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.lato(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(16),
                ],
              ),
              const Gap(40),
              CustomTextField(
                labelText: 'Username',
                hintText: 'Enter an username',
                controller: emailController,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    return null;
                  } else {
                    return 'You need to input a username';
                  }
                },
              ),
              const Gap(16),
              CustomTextField(
                key: const Key('password-field'),
                labelText: 'Password',
                hintText: 'Enter a password',
                isPassword: true,
                controller: passwordController,
                onChanged: (val) {
                  setState(() {
                    if (val.isValidPassword) {
                      isValidPassword = true;
                    } else {
                      isValidPassword = false;
                    }
                  });
                },
                validator: (val) {
                  if (val!.isValidPassword) {
                    return null;
                  } else {
                    return 'Use at least 8 characters';
                  }
                },
              ),
              const Gap(40),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    // MatrixService.client.logout();

                    MatrixService.login(
                      username: emailController.text,
                      password: passwordController.text,
                    ).then((value) {
                      navigator.replaceTop(const RoomListPage());
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Log in',
                        style:
                            GoogleFonts.lato(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
