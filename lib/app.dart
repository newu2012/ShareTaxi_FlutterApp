import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'trip/logic/map_controller.dart';
import 'trip/presentation/pages/pages.dart';
import 'chat/presentation/pages/chat_page.dart';
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
        ChangeNotifierProvider<MapController>(
          create: (_) => MapController(),
        ),
      ],
      child: Consumer<FireUserDao>(
        builder: (context1, userDao, child) => MaterialApp(
          theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 111, 108, 217),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 111, 108, 217),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: const Color.fromARGB(255, 111, 108, 217),
              ),
            ),
          ),
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
      case '/trips':
        return MaterialPageRoute(builder: (context) => const TripsListPage());
      case '/createTrip':
        return MaterialPageRoute(builder: (context) => const CreateTripPage());
      case '/chat':
        return MaterialPageRoute(
          builder: (context) => ChatPage(
            tripId: settings.arguments as String,
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => const UnknownPage());
    }
  }
}
