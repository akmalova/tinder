import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/screens/cards.dart';
import 'package:tinder/screens/finish.dart';

// Cтраница, которая откроет либо карточки с другими пользователями,
// либо страницу финиша, если карточек не осталось
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Timer _timer;

  Future<void> initData() async {
    await context.read<AppCubit>().initIdsAndImages();
  }

  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 600), initData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state is AppCards) {
            return const Cards();
          } else if (state is AppFinish) {
            return const Finish();
          } else {
            return Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Colors.deepPurple[400],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
