import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/router/router.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeRoute(), LeaderBoardRoute(), StoreRoute(), AccountRoute()],
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBar(
          onDestinationSelected: tabsRouter.setActiveIndex,
          selectedIndex: tabsRouter.activeIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Главная',
            ),
            NavigationDestination(
              icon: Icon(Icons.workspace_premium),
              label: 'Лидеры',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_mall_outlined),
              label: 'Store',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'Account',
            ),
          ],
        );
      },
    );
  }
}
