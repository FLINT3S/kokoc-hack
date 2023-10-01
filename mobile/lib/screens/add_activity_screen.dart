import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  @override
  initState() {
    super.initState();

    () async {
      PermissionStatus permissionStatus0 = await Permission.storage.status;

      if (permissionStatus0 != PermissionStatus.granted) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        setState(() {
          permissionStatus0 = permissionStatus;
        });
      }
    }();
  }

  List<File> images = [];

  Future pickImage() async {
    try {
      final receivedImages =
          await ImagePicker().pickMultiImage(requestFullMetadata: true);
      if (receivedImages.isEmpty) return;
      final imagesTemp = receivedImages.map((i) => File(i.path)).toList();
      setState(() => images = imagesTemp);
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  int addActivityStep = 0;
  String? activityType = 'Плавание';

  TextEditingController durationController = TextEditingController();
  String? runIntensity;
  String? swimStyle;

  void goToNextStep() {
    if (addActivityStep == 0) {
      setState(() {
        addActivityStep = 1;
      });
    } else if (addActivityStep == 1) {
      addActivity();
    }
  }

  void showSnackBar(String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 7),
        content: Text(text),
        action: SnackBarAction(
          label: 'Закрыть',
          onPressed: () {},
        ),
      ));
    });
  }

  void saveActivityToSP(Object activity) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    List<String> oldActivities = sp.getStringList('savedActivities') ?? [];
    oldActivities.add(jsonEncode(activity));
    sp.setStringList('savedActivities', oldActivities);
  }

  void addActivity() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    double weight = sp.getDouble('userWeight') ?? 70;

    if (activityType == 'Бег') {
      if (runIntensity == null ||
          durationController.value.text == '' ||
          int.tryParse(durationController.value.text)! <= 0) {
        showSnackBar('Заполните все поля тренировки!');
      } else {
        int met;
        switch (runIntensity) {
          case 'Умеренная (6-8 км/ч)':
            met = 8;
          case 'Выше среднего (9-13 км/ч)':
            met = 10;
          case 'Высокая (более 13 км/ч)':
            met = 12;
          default:
            met = 10;
        }
        double durationHours =
            (int.tryParse(durationController.value.text)! / 60);
        double burnedEnergy = durationHours * met * weight;

        saveActivityToSP({
          'type': 'run',
          'burnedEnergy': burnedEnergy,
          'duration': int.tryParse(durationController.value.text),
          'runIntensity': runIntensity,
          'images': images.map((i) => i.path).toList()
        });

        AutoRouter.of(context).navigateNamed('/');
      }
    } else if (activityType == 'Плавание') {
      if (swimStyle == null ||
          durationController.value.text == '' ||
          int.tryParse(durationController.value.text)! <= 0) {
        showSnackBar('Заполните все поля тренировки!');
      } else {
        int met;
        switch (runIntensity) {
          case 'Брасс':
            met = 7;
          case 'Кроль':
            met = 10;
          case 'Баттерфляй':
            met = 14;
          default:
            met = 10;
        }
        double durationHours =(int.tryParse(durationController.value.text)! / 60);
        double burnedEnergy = durationHours * met * weight;

        saveActivityToSP({
          'type': 'swim',
          'burnedEnergy': burnedEnergy,
          'duration': int.tryParse(durationController.value.text),
          'swimStyle': swimStyle,
          'images': images.map((i) => i.path).toList()
        });

        AutoRouter.of(context).navigateNamed('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: FilledButton(
          onPressed: goToNextStep,
          child: Center(
            child: Text(addActivityStep == 0 ? 'Продолжить' : 'Сохранить'),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              child: (() {
                if (addActivityStep == 0) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: Text('Добавление активности',
                              style: TextStyle(fontSize: 24)),
                        ),
                        ListTile(
                            title: const Text('Бег'),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            leading: Radio<String>(
                              value: 'Бег',
                              groupValue: activityType,
                              onChanged: (String? value) {
                                setState(() {
                                  activityType = value;
                                });
                              },
                            )),
                        ListTile(
                            title: const Text('Плавание'),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            leading: Radio<String>(
                              value: 'Плавание',
                              groupValue: activityType,
                              onChanged: (String? value) {
                                setState(() {
                                  activityType = value;
                                });
                              },
                            )),
                        ListTile(
                            title: const Text('Силовые упражнения'),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            leading: Radio<String>(
                              value: 'Силовые упражнения',
                              groupValue: activityType,
                              onChanged: (String? value) {
                                setState(() {
                                  activityType = value;
                                });
                              },
                            )),
                        ListTile(
                            title: const Text('Велосипед'),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            leading: Radio<String>(
                              value: 'Велосипед',
                              groupValue: activityType,
                              onChanged: (String? value) {
                                setState(() {
                                  activityType = value;
                                });
                              },
                            ))
                      ]);
                } else {
                  if (activityType == 'Бег') {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text('Данные активности',
                                style: TextStyle(fontSize: 24)),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: durationController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: 'Продолжительность (в минутах)',
                                filled: true),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Text('Интенсивность бега'),
                          ),
                          ListTile(
                              title: const Text('Умеренная (6-8 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Умеренная (6-8 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Выше среднего (9-13 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Выше среднего (9-13 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Высокая (более 13 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Высокая (более 13 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextButton(
                                onPressed: pickImage,
                                child: const Text('Выбрать фото')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: SizedBox(
                              height: 150,
                              child: Expanded(
                                child: ListView(
                                  // This next line does the trick.
                                  scrollDirection: Axis.horizontal,
                                  children: images.map((file) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.file(
                                              file,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ]);
                  }
                  if (activityType == 'Плавание') {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text('Данные активности',
                                style: TextStyle(fontSize: 24)),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: durationController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: 'Продолжительность (в минутах)',
                                filled: true),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Text('Стиль плавания'),
                          ),
                          ListTile(
                              title: const Text('Брасс'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Брасс',
                                groupValue: swimStyle,
                                onChanged: (String? value) {
                                  setState(() {
                                    swimStyle = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Кроль'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Кроль',
                                groupValue: swimStyle,
                                onChanged: (String? value) {
                                  setState(() {
                                    swimStyle = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Баттерфляй'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Баттерфляй',
                                groupValue: swimStyle,
                                onChanged: (String? value) {
                                  setState(() {
                                    swimStyle = value;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextButton(
                                onPressed: pickImage,
                                child: const Text('Выбрать фото')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: SizedBox(
                              height: 150,
                              child: Expanded(
                                child: ListView(
                                  // This next line does the trick.
                                  scrollDirection: Axis.horizontal,
                                  children: images.map((file) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.file(
                                              file,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ]);
                  }
                  if (activityType == 'Силовые упражнения') {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text('Данные активности',
                                style: TextStyle(fontSize: 24)),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: durationController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: 'Продолжительность (в минутах)',
                                filled: true),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Text('Интенсивность бега'),
                          ),
                          ListTile(
                              title: const Text('Умеренная (6-8 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Умеренная (6-8 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Выше среднего (9-13 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Выше среднего (9-13 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Высокая (более 13 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Высокая (более 13 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextButton(
                                onPressed: pickImage,
                                child: const Text('Выбрать фото')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: SizedBox(
                              height: 150,
                              child: Expanded(
                                child: ListView(
                                  // This next line does the trick.
                                  scrollDirection: Axis.horizontal,
                                  children: images.map((file) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.file(
                                              file,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ]);
                  }
                  if (activityType == 'Велосипед') {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text('Данные активности',
                                style: TextStyle(fontSize: 24)),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: durationController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: 'Продолжительность (в минутах)',
                                filled: true),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Text('Интенсивность бега'),
                          ),
                          ListTile(
                              title: const Text('Умеренная (6-8 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Умеренная (6-8 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Выше среднего (9-13 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Выше среднего (9-13 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          ListTile(
                              title: const Text('Высокая (более 13 км/ч)'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              leading: Radio<String>(
                                value: 'Высокая (более 13 км/ч)',
                                groupValue: runIntensity,
                                onChanged: (String? value) {
                                  setState(() {
                                    runIntensity = value;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextButton(
                                onPressed: pickImage,
                                child: const Text('Выбрать фото')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: SizedBox(
                              height: 150,
                              child: Expanded(
                                child: ListView(
                                  // This next line does the trick.
                                  scrollDirection: Axis.horizontal,
                                  children: images.map((file) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.file(
                                              file,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ]);
                  }
                }
              }()))),
    );
  }
}
