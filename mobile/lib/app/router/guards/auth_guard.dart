import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/router/router.dart';
import 'package:mobile/services/auth_service.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    AuthService authService = GetIt.I<AuthService>();

    if (!await authService.isSignedIn()) {
      log('AuthGuard > is not signed in, redirecting to Auth');
      resolver.redirect(AuthRoute());
      return;
    }

    // TODO: Валидация токена только при онлайне
    // if (!await authService.isTokenValid()) {
    //   log('AuthGuard > token is not valid, redirecting to Auth');
    //   resolver.redirect(AuthRoute(
    //       reason: 'Невалидный токен, требуется перезайти в приложение'));
    //   return;
    // }

    resolver.next(true);
  }
}
