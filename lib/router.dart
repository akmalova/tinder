import 'package:flutter/material.dart';
import 'package:tinder/routes.dart';
import 'package:tinder/screens/app.dart';
import 'package:tinder/screens/auth.dart';
import 'package:tinder/screens/cards.dart';
import 'package:tinder/screens/finish.dart';
import 'package:tinder/screens/registration.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.auth:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Auth());
      case Routes.registration:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Registration());
      case Routes.cards:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Cards());
      case Routes.finish:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Finish());
      case Routes.app:
        return MaterialPageRoute(
            builder: (BuildContext context) => const App());
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Scaffold(
            body: Center(
              child: Text('Navigation Error'),
            ),
          ),
        );
    }
  }
}
