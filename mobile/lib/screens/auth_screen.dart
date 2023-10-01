import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/model/messages/constants.dart';
import 'package:mobile/services/auth_service.dart';

import '../services/api/result.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {
  final String? reason;

  const AuthScreen({super.key, this.reason});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? loginReason;
  bool isLoading = false;
  String? loginError;
  String? passwordError;

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.reason != null && widget.reason is String) {
      setState(() {
        loginReason = widget.reason!;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 7),
          content: Text(loginReason!),
          action: SnackBarAction(
            label: 'Закрыть',
            onPressed: () {},
          ),
        ));
      });
    }
  }

  void onPressedSubmit() async {
    bool hasErrors = false;

    setState(() {
      if (loginController.value.text == '') {
        loginError = 'Введите логин';
        hasErrors = true;
      }
      if (passwordController.value.text == '') {
        passwordError = 'Введите пароль';
        hasErrors = true;
      }
    });

    if (hasErrors) return;

    setState(() {
      isLoading = true;
    });

    Result<String> result = await GetIt.I<AuthService>()
        .obtainToken(loginController.value.text, passwordController.value.text);

    setState(() {
      isLoading = false;
    });

    if (!result.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.error),
          showCloseIcon: true,
        ));
      });
    } else {
      AutoRouter.of(context).replaceNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.help),
              tooltip: 'Онбординг',
              onPressed: () {
                context.router.replaceNamed('/onboarding');
              },
            )
          ],
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    nameApp,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: Column(
                      children: [
                        TextField(
                            controller: loginController,
                            decoration: InputDecoration(
                                errorText: loginError,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: 'Логин',
                                filled: true)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  errorText: passwordError,
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: 'Пароль',
                                  filled: true)),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: FilledButton.icon(
                                  onPressed: onPressedSubmit,
                                  label: const Text('Войти'),
                                  icon: isLoading
                                      ? Container(
                                          width: 24,
                                          height: 24,
                                          padding: const EdgeInsets.all(2.0),
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Icon(Icons.login)),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
