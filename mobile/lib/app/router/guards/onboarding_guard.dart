import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/router/router.dart';
import 'package:mobile/services/onboarding_service.dart';

class OnboardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await GetIt.I<OnboardingService>().isOnboardingCompleted()) {
      resolver.next(true);
    } else {
      log('OnboardingGuard > onboarding is not completed, redirecting to onboarding');
      resolver.redirect(const OnboardingRoute());
    }
  }
}
