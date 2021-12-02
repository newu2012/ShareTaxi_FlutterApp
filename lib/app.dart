import 'package:flutter/material.dart';

import 'home.dart';
import 'common/unknown_page.dart';
import 'login/presentation/pages/signup_page.dart';
import 'login/presentation/pages/login_page.dart';
import 'trip/trip.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  // TODO remove trips placeholder
  static final trips = <Trip>[
    Trip('С Меги на Ботанику', 1, 4, 240,
        DateTime.now().add(const Duration(minutes: 30))),
    Trip('С Ботанику в Мегу', 3, 4, 500,
        DateTime.now().add(const Duration(minutes: 35))),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      initialRoute: '/login',
      onGenerateRoute: (settings) => OnGenerateRoute(settings),
    );
  }

  static MaterialPageRoute OnGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        //  TODO Change to OnboardingPage()
        return MaterialPageRoute(builder: (context) => const UnknownPage());
      case '/login':
        //  TODO Change to OnboardingPage()
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/signup':
        //  TODO Change to OnboardingPage()
        return MaterialPageRoute(builder: (context) => const SignupPage());
      case '/':
        //  TODO Change to OnboardingPage()
        return MaterialPageRoute(
            builder: (context) => Home(trips: trips));

      default:
        return MaterialPageRoute(builder: (context) => const UnknownPage());
    }
  }
}
