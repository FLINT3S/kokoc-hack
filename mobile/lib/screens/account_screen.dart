import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  double? currentWeight;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((inst) => {
          setState(() {
            currentWeight = inst.getDouble('userWeight');
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Center(
                child: CircleAvatar(
                    radius: 100,
                    child: ClipOval(
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://s1.afisha.ru/mediastorage/02/68/50c66e7f825c4e82828ffaa96802.jpg'))))),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Михаил Петров',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Информация о профиле',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 22),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Моя компания',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.left),
                              Text('АО "НИЦ ЭТУ СПб"',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.left),
                            ])),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Мое подразделение',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.left),
                              Text('ДПО ОВП',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.left),
                            ])),
                    GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).navigateNamed('/user-details');
                      },
                      child: SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text('Мой вес',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.left),
                                  Text('Текущий вес: $currentWeight',
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.left),
                                ])),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider()),
                    const SizedBox(
                      child: Text(
                        'Пожертвования',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        log('tap');
                      },
                      child: const SizedBox(
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Фонд “Подари жизнь”',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.left),
                                  Text('Выбранный фонд для пожертвований',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.left),
                                ])),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider()),
                    const SizedBox(
                      child: Text(
                        'Настройки',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  title: const Text('Скрывать моё имя'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  subtitle: const Text(
                                      'Вместо Вашего имени в таблице лидеров будет отображаться "Пользователь скрыт"'),
                                  trailing: Switch(
                                      value: true,
                                      onChanged: (bool v) {
                                        log(v.toString());
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Темная тема'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  subtitle:
                                      const Text('Переключите тему приложения'),
                                  trailing: Consumer<ThemeProvider>(builder:
                                      (BuildContext context,
                                          ThemeProvider themeProvider,
                                          Widget? child) {
                                    return Switch(
                                        value: themeProvider.currentThemeMode ==
                                            ThemeMode.dark,
                                        onChanged: (bool v) {
                                          log(v.toString());
                                          themeProvider.toggleTheme();
                                        });
                                  }),
                                )
                              ])),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
