import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/router/guards/auth_guard.dart';

import 'package:mobile/screens/auth_screen.dart';
import 'package:mobile/screens/dashboard_screen.dart';
import 'package:mobile/screens/main_screen.dart';
import 'package:mobile/screens/onboarding_screen.dart';
import 'package:mobile/screens/leaderboard_screen.dart';
import 'package:mobile/screens/account_screen.dart';
import 'package:mobile/screens/store_screen.dart';
import 'package:mobile/screens/add_activity_screen.dart';
import 'package:mobile/screens/user_details_screen.dart';

import 'guards/onboarding_guard.dart';
import 'guards/user_details_guard.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes =>
      [
        AutoRoute(
            page: MainRoute.page,
            path: '/',
            guards: [OnboardingGuard(), AuthGuard(), UserDetailsGuard()],
            children: [
              AutoRoute(
                  page: HomeRoute.page,
                  path: ''
              ),
              AutoRoute(
                page: LeaderBoardRoute.page,
                path: 'leaderboard',
              ),
              AutoRoute(
                page: StoreRoute.page,
                path: 'store',
              ),
              AutoRoute(
                page: AccountRoute.page,
                path: 'account',
              )
            ]),
        AutoRoute(
          page: AddActivityRoute.page,
          path: '/addActivity'
        ),
        AutoRoute(
          page: OnboardingRoute.page,
          path: '/onboarding',
        ),
        AutoRoute(
          page: AuthRoute.page,
          path: '/auth'
        ),
        AutoRoute(
          page: UserDetailsRoute.page,
          path: '/user-details'
        )
      ];
}
