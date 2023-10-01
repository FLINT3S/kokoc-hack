import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:mobile/app/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (!((await SharedPreferences.getInstance()).getBool('isUserDetailsSelected') ?? false)) {
      log('UserDetailsGuard > details is not specified, redirecting');
      resolver.redirect(const UserDetailsRoute());
    } else {
      resolver.next(true);
    }
  }
}
