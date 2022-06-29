import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Timer _timer;

  Future<void> initData() async {
    await context.read<AppCubit>().initData();
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer(const Duration(seconds: 2), initData);
    return Scaffold(
      body: BlocConsumer<AppCubit, AppState>(listener: (context, state) {
        if (state is AppCards) {
          Navigator.of(context).pushReplacementNamed(Routes.cards);
        } else if (state is AppFinish) {
          Navigator.of(context).pushReplacementNamed(Routes.finish);
        }
      }, builder: (context, state) {
        return Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: Colors.deepPurple[400],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
