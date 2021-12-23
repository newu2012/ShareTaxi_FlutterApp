import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'app.dart';
import 'common/presentation/pages/unknown_page.dart';
import 'trip/presentation/pages/pages.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final PersistentTabController _tabController =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _tabController,
      screens: [
        const MainPage(),
        const TripsListPage(), // TODO Change to const ChatsListPage(),
        const UnknownPage(),
      ],
      items: _navBarsItems(context),
      navBarStyle: NavBarStyle.style1,
      resizeToAvoidBottomInset: true,
      hideNavigationBar: true,
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      _shareTaxiBottomNavBarItem(
        context,
        const Icon(Icons.home),
        'Главная',
      ),
      _shareTaxiBottomNavBarItem(
        context,
        const Icon(Icons.chat),
        'Чаты',
      ),
      _shareTaxiBottomNavBarItem(
        context,
        const Icon(Icons.account_circle),
        'Профиль',
      ),
    ];
  }

  PersistentBottomNavBarItem _shareTaxiBottomNavBarItem(
    BuildContext context,
    Icon icon,
    String title,
  ) {
    return PersistentBottomNavBarItem(
      icon: icon,
      title: title,
      activeColorPrimary: Colors.deepPurple,
      inactiveColorPrimary: Colors.grey,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        onGenerateRoute: (settings) => App.OnGenerateRoute(context, settings),
      ),
    );
  }
}
