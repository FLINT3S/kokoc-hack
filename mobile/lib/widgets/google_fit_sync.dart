import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:mobile/services/google_fit_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleFitSync extends StatefulWidget {
  const GoogleFitSync({super.key});

  @override
  State<GoogleFitSync> createState() => _GoogleFitSyncState();
}

class _GoogleFitSyncState extends State<GoogleFitSync> {
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((inst) {
      setState(() {
        googleFitAuthorized = inst.getBool('googleFitAuthorized') ?? false;
      });
    });
  }

  bool googleFitAuthorized = false;
  int? todaySteps;

  final permissions =
      dataTypesAndroid.map((e) => HealthDataAccess.READ_WRITE).toList();

  void onPressedSyncButton() async {
    var sp = await SharedPreferences.getInstance();

    if (!(sp.getBool('googleFitAuthorized') ?? false)) {
      authorize();
    } else {
      fetchTodayStepData();
    }
  }

  Future authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions =
        await health.hasPermissions(dataTypesAndroid, permissions: permissions);

    hasPermissions = false;


    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        await health.requestAuthorization(dataTypesAndroid,
            permissions: permissions);
        (await SharedPreferences.getInstance())
            .setBool('googleFitAuthorized', true);
        setState(() {
          googleFitAuthorized = true;
        });
      } catch (error) {
        log('Exception in authorize: $error');
      }
    }
  }

  Future fetchTodayStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day - 1);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        log("Caught exception in getTotalStepsInInterval: $error");
      }

      setState(() {
        todaySteps = (steps == null) ? 0 : steps;
      });
    } else {
      log("Не авторизован");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Интеграция с сервисами',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: onPressedSyncButton,
                      child: Text(googleFitAuthorized ? 'Синхронизировать трекер' : 'Подключить GoogleFit'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8), child: Text('Шагов за сегодня: $todaySteps'),)
                ])),
          ],
        ),
      ),
    );
  }
}
