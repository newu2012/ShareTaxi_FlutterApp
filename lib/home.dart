import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'app.dart';
import 'common/presentation/unknown_page.dart';
import 'trip/presentation/widgets/google_map_widget.dart';
import 'trip/Presentation/pages/trips_list_page.dart';

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
        const TripsListPage(),
        const GoogleMapWidget(),
        const TripsListPage(),
        // const MessageList(),
        const UnknownPage()
      ],
      items: _navBarsItems(context),
      navBarStyle: NavBarStyle.style3,
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ('Главная'),
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) => App.OnGenerateRoute(context, settings),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.local_taxi),
        title: ('Новая поездка'),
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) => App.OnGenerateRoute(context, settings),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        title: ('Чаты'),
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) => App.OnGenerateRoute(context, settings),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle),
        title: ('Профиль'),
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) => App.OnGenerateRoute(context, settings),
        ),
      ),
    ];
  }
}
