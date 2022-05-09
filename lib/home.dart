import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'profile/user_page.dart';
import 'app.dart';
import 'chat/presentation/pages/chat_list_page.dart';
import 'common/data/fire_user_dao.dart';
import 'trip/presentation/pages/pages.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final PersistentTabController _tabController =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    final _fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    return PersistentTabView(
      context,
      controller: _tabController,
      screens: [
        const MainPage(),
        const ChatListPage(),
        UserPage(userId: _fireUserDao.userId()!),
      ],
      items: _navBarsItems(context),
      navBarStyle: NavBarStyle.style1,
      resizeToAvoidBottomInset: true,
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      _carpoolingHelperBottomNavBarItem(
        context,
        const Icon(Icons.home),
        'Главная',
      ),
      _carpoolingHelperBottomNavBarItem(
        context,
        const Icon(Icons.chat),
        'Чаты',
      ),
      _carpoolingHelperBottomNavBarItem(
        context,
        const Icon(Icons.account_circle),
        'Профиль',
      ),
    ];
  }

  PersistentBottomNavBarItem _carpoolingHelperBottomNavBarItem(
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
