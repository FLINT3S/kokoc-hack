import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  Future<bool> isOnboardingCompleted() async {
    return (await SharedPreferences.getInstance())
            .getBool('isOnboardingCompleted') ??
        false;
  }

  Future<void> setOnboardingCompleted({bool state = true}) async {
    (await SharedPreferences.getInstance())
        .setBool('isOnboardingCompleted', state);
  }
}
