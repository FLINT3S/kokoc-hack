import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  List<dynamic> leaderBoardUsers = [];
  dynamic currentCompany;

  Future loadCompany() async {
    var sp = await SharedPreferences.getInstance();

    var response = await GetIt.I<Dio>().get(
        'https://kokoc.flint3s.ru/api/companies/get/${sp.getInt('userCompanyId')!}');

    setState(() {
      currentCompany = response.data;
    });
  }

  Future loadLeaderboard() async {
    var sp = await SharedPreferences.getInstance();

    var response = await GetIt.I<Dio>().get(
        'https://kokoc.flint3s.ru/api/activities/get-employees-descending-list-in_company/${sp.getInt('userCompanyId')!}');

    setState(() {
      leaderBoardUsers = List.from(response.data);
    });
  }

  void loadAll() async {
    await loadCompany();
    await loadLeaderboard();
  }

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лидерборд'),
        actions: [
          IconButton(onPressed: loadAll, icon: const Icon(Icons.refresh))
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: leaderBoardUsers.asMap().entries.map((e) {
            dynamic user = e.value;
            int index = e.key;

            return ListTile(
              title: Text(
                  '${user['employee']['name']} ${user['employee']['surname']}'),
              leading: CircleAvatar(child: Text('${index + 1}')),
              trailing: Text('${double.parse(user['kilocalories_count'].toString()) * double.parse(currentCompany['cost_of_unit'].toString())} ₽'),
            );
          }).toList()),
    );
  }
}
