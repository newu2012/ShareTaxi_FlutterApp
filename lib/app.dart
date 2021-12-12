import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat/presentation/message_list.dart';
import 'chat/data/message_dao.dart';
import 'common/data/fire_user_dao.dart';
import 'common/data/user_dao.dart';
import 'home.dart';
import 'common/presentation/pages/unknown_page.dart';
import 'login/presentation/pages/signup_page.dart';
import 'login/presentation/pages/login_page.dart';
import 'trip/data/trip_dao.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDao>(
          lazy: false,
          create: (_) => UserDao(),
        ),
        ChangeNotifierProvider<FireUserDao>(
          lazy: false,
          create: (_) => FireUserDao(),
        ),
        ChangeNotifierProvider<TripDao>(
          lazy: false,
          create: (_) => TripDao(),
        ),
        Provider<MessageDao>(
          lazy: false,
          create: (_) => MessageDao(),
        ),
      ],
      child: Consumer<FireUserDao>(
        builder: (context1, userDao, child) => MaterialApp(
          theme: ThemeData.light(),
          initialRoute: '/login',
          onGenerateRoute: (settings) => OnGenerateRoute(context1, settings),
        ),
      ),
    );
  }

  static MaterialPageRoute OnGenerateRoute(
    BuildContext context,
    RouteSettings settings,
  ) {
    if (!Provider.of<FireUserDao>(context, listen: false).isLoggedIn()) {
      switch (settings.name) {
        case '/onboarding':
          //  TODO Change to OnboardingPage()
          return MaterialPageRoute(builder: (context) => const UnknownPage());
        case '/login':
          return MaterialPageRoute(builder: (context) => const LoginPage());
        case '/signup':
          return MaterialPageRoute(builder: (context) => const SignupPage());
        default:
          return MaterialPageRoute(builder: (context) => const UnknownPage());
      }
    }

    switch (settings.name) {
      case '/onboarding':
        //  TODO Change to OnboardingPage()
        return MaterialPageRoute(builder: (context) => const UnknownPage());
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (context) => const SignupPage());
      case '/':
        return MaterialPageRoute(builder: (context) => Home());
      case '/chat':
        return MaterialPageRoute(
          builder: (context) => MessageList(
            tripId: settings.arguments as String?,
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => const UnknownPage());
    }
  }
}
