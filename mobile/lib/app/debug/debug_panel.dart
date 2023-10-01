import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/services/onboarding_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugPanel extends StatelessWidget {
  const DebugPanel({super.key});

  void onPressedChangeOnboardingState() async {
    await GetIt.I<OnboardingService>().setOnboardingCompleted(state: false);
  }

  void onPressedAuthClear() async {
    (await SharedPreferences.getInstance()).remove('authToken');
    (await SharedPreferences.getInstance()).remove('isSignedIn');
  }

  void onPressedSavedActivitiesClear() async {
    (await SharedPreferences.getInstance()).remove('savedActivities');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FilledButton(
          onPressed: onPressedChangeOnboardingState,
          child: const Text('Onboarding reload')),
      FilledButton(
          onPressed: onPressedAuthClear,
          child: const Text('Auth Clear')),
      FilledButton(
          onPressed: onPressedSavedActivitiesClear,
          child: const Text('SavedActivities Clear'))
    ]);
  }
}
