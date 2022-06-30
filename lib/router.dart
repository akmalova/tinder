import 'package:flutter/material.dart';
import 'package:tinder/routes.dart';
import 'package:tinder/screens/app.dart';
import 'package:tinder/screens/auth.dart';
import 'package:tinder/screens/cards.dart';
import 'package:tinder/screens/finish.dart';
import 'package:tinder/screens/auth_initial.dart';
import 'package:tinder/screens/rating.dart';
import 'package:tinder/screens/registration.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AuthInitial());
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
      case Routes.rating:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Rating());
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
