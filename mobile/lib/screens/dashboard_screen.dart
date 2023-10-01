import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/debug/debug_panel.dart';
import 'package:mobile/model/messages/constants.dart';
import 'package:mobile/widgets/google_fit_sync.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dashboard_chart.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedChartView = 'Дни';
  int numSavedActivities = 0;
  dynamic currentCompany;
  dynamic currentActivity;

  @override
  initState() {
    super.initState();

    SharedPreferences.getInstance().then((inst) {
      Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          numSavedActivities =
              inst.getStringList('savedActivities')?.length ?? 0;
        });
      });
    });

    loadAll();
  }

  void onPressedAddActivity() {
    AutoRouter.of(context).pushNamed('/addActivity');
  }

  Future loadCompany() async {
    var sp = await SharedPreferences.getInstance();

    var response = await GetIt.I<Dio>().get(
        'https://kokoc.flint3s.ru/api/companies/get/${sp.getInt('userCompanyId')!}');

    setState(() {
      currentCompany = response.data;
    });
  }

  Future loadCurrentMonthStats() async {
    var sp = await SharedPreferences.getInstance();
    final now = DateTime.now();

    var response = await GetIt.I<Dio>().post(
        'https://kokoc.flint3s.ru/api/activities/get-by-date-and-employee',
        data: jsonEncode({
          'employee_id': sp.getInt('employeeId')!,
          'month': now.month,
          'year': now.year,
        }));
    setState(() {
      currentActivity = response.data;
    });
  }

  loadAll() async {
    await loadCompany();
    await loadCurrentMonthStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: onPressedAddActivity,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(nameApp),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(children: [
                    Text(
                        '${double.parse(currentActivity?['kilocalories_count']?.toString() ?? '0') * double.parse(currentCompany?['cost_of_unit']?.toString() ?? '0')} ₽',
                        style: const TextStyle(fontSize: 48, height: 1),
                        textAlign: TextAlign.center),
                    const Text('уже конвертировано в пожертвования',
                        textAlign: TextAlign.center),
                  ])),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(children: [
                          Text(
                              '${double.parse(currentActivity?['kilocalories_count']?.toString() ?? '0')}',
                              style: const TextStyle(fontSize: 26)),
                          const Text('ккал потрачено всего')
                        ])),
                    const Expanded(
                        flex: 1,
                        child: Column(children: [
                          Text('35', style: TextStyle(fontSize: 26)),
                          Text('дней в программе')
                        ]))
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: SegmentedButton(
                          emptySelectionAllowed: false,
                          onSelectionChanged: (selected) {
                            setState(() {
                              selectedChartView = selected.first;
                            });
                          },
                          segments: const [
                            ButtonSegment(value: 'Дни', label: Text('Дни')),
                            ButtonSegment(
                                value: 'Недели', label: Text('Недели')),
                            ButtonSegment(
                                value: 'Месяцы', label: Text('Месяцы')),
                          ],
                          selected: {selectedChartView},
                        ),
                      ),
                      const DashboardChart()
                    ],
                  ),
                ),
              ),
              (() {
                if (numSavedActivities > 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                      '$numSavedActivities записей ожидают синхронизации',
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.start),
                                ),
                                const Text(
                                    'Подключитесь к интернету чтобы все данные синхронизировались',
                                    textAlign: TextAlign.start),
                              ])),
                          LinearProgressIndicator(
                              color: Theme.of(context).primaryColor)
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }()),
              const GoogleFitSync(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: const Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text('Мои активности',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16)),
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3, child: Text('Бег')),
                                Expanded(flex: 1, child: Text('29.09'))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3, child: Text('Плавание')),
                                Expanded(flex: 1, child: Text('28.09'))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3, child: Text('Бег')),
                                Expanded(flex: 1, child: Text('28.09'))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 3, child: Text('Силовая тренировка')),
                                Expanded(flex: 1, child: Text('27.09'))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3, child: Text('Бег')),
                                Expanded(flex: 1, child: Text('25.09'))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3, child: Text('Бег')),
                                Expanded(flex: 1, child: Text('24.09'))
                              ],
                            )
                          ])),
                    ],
                  ),
                ),
              ),
              // const DebugPanel()
            ],
          ),
        )));
  }
}
