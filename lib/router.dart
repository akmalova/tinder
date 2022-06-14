import 'package:flutter/material.dart';
import 'package:tinder/screens/auth.dart';
import 'package:tinder/screens/cards.dart';
import 'package:tinder/screens/finish.dart';
import 'package:tinder/screens/registration.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
          case '/auth':
            return MaterialPageRoute(
                builder: (BuildContext context) => const Auth());
          case '/registration':
            return MaterialPageRoute(
                builder: (BuildContext context) => const Registration());
          case '/cards':
            return MaterialPageRoute(
                builder: (BuildContext context) => const Cards());
          case '/finish':
            return MaterialPageRoute(
                builder: (BuildContext context) => const Finish());
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