import 'package:mobile/model/messages/constants.dart';
import 'package:mobile/model/onboarding/onboarding_item.dart';

final List<OnboardingItem> onboardingData = [
  OnboardingItem(
      header: 'Привет!',
      description:
          'Это $nameApp - приложение, которое помогает соединить любовь к спорту и благотворительность',
      imageAsset: 'assets/onboarding/hello.svg'),
  OnboardingItem(
      header: 'Простая и благородная связь',
      description:
          'Ваше участие в спорте теперь также служит благотворительным целям',
      imageAsset: 'assets/onboarding/sport.svg'),
  OnboardingItem(
      header: 'Начнём?',
      description:
          'Присоединяйтесь к тем, кто уже помогает своей активностью тысячам людей!',
      imageAsset: 'assets/onboarding/hands.svg')
];
