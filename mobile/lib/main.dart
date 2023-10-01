import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/onboarding_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router/router.dart';

void main() {
  GetIt.I.registerSingleton<OnboardingService>(OnboardingService());
  GetIt.I.registerSingleton<AuthService>(AuthService());
  GetIt.I.registerSingleton<Dio>(Dio());

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: CharityMotionApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _currentThemeMode = ThemeMode.light;

  ThemeMode get currentThemeMode => _currentThemeMode;

  void toggleTheme() {
    _currentThemeMode = (_currentThemeMode == ThemeMode.light)
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

class CharityMotionApp extends StatefulWidget {
  const CharityMotionApp({super.key});

  @override
  State<CharityMotionApp> createState() => _CharityMotionAppState();
}

class _CharityMotionAppState extends State<CharityMotionApp> {
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (await InternetConnectionChecker().hasConnection) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        List<String> savedActivities = sp.getStringList('savedActivities') ?? [];
        int currentUserEmployeeId = sp.getInt('employeeId')!;

        for (String activity in savedActivities) {
          dynamic activityObject = jsonDecode(activity);
          List<String> uploadedPhotos = [];

          if (List.from(activityObject['images']).isNotEmpty) {
            for (String imgPath in List.from(activityObject['images'])) {
              var formData = FormData.fromMap({
                'file': await MultipartFile.fromFile(imgPath, filename: 'photo.png')
              });
              var response = await GetIt.I<Dio>().post('https://kokoc.flint3s.ru/api/activities/save_training_image', data: formData);
              uploadedPhotos.add(response.data);
            }
          }

          try {
            var r = await GetIt.I<Dio>().post('https://kokoc.flint3s.ru/api/activities/create-activity-request', data: jsonEncode({
              'employee_id': currentUserEmployeeId,
              'images': jsonEncode(uploadedPhotos),
              'training_information': jsonEncode(activityObject),
              'adding_kilocalories_count': activityObject['burnedEnergy']
            }));
            log(r.toString());
          } catch (e) {
            log(e.toString());
          }
        }

        sp.remove('savedActivities');
      }
    });
  }

  final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
  );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'CharityMotion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      darkTheme: darkTheme,
      themeMode: themeProvider.currentThemeMode,
      routerConfig: _appRouter.config(),
    );
  }
}
