import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/cards_cubit.dart';
import 'package:tinder/routes.dart';
import 'package:tinder/screens/cards.dart';
import 'package:tuple/tuple.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Tuple2<String, String>> _data = [];
  late final Timer _timer;

  Future<void> initData() async {
    _data.addAll(await context.read<CardsCubit>().initData());
    route();
  }

  void route() {
    if (_data.isEmpty) {
      Navigator.of(context).pushReplacementNamed(Routes.finish);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.cards);
    }
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer(const Duration(seconds: 1), initData);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.deepPurple[400]),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
}
