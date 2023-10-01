import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  TextEditingController weightInputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((inst) => {
      weightInputController.text = (inst.getDouble('userWeight') ?? '').toString()
    });
  }

  void onPressedSaveDetails() async {
    if (double.tryParse(weightInputController.value.text) != null) {
      (await SharedPreferences.getInstance()).setDouble('userWeight', double.parse(weightInputController.value.text));
      (await SharedPreferences.getInstance()).setBool('isUserDetailsSelected', true);
      AutoRouter.of(context).replaceNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавление данных')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: FilledButton(
          onPressed: onPressedSaveDetails,
          child: const Center(
            child: Text('Сохранить'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            TextField(
                controller: weightInputController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Вес в килограммах',
                    filled: true)),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Пожалуйста укажите Ваш текущий вес, чтобы мы могли рассчитать вашу активность'),
            )
          ],
        ),
      ),
    );
  }
}
