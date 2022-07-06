import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/screens/app.dart';
import 'package:tinder/screens/auth.dart';

// Начальная страница приложения, которая откроет либо страницу авторизации,
// либо само приложение, если пользователь уже авторизован
class AuthInitial extends StatefulWidget {
  const AuthInitial({super.key});

  @override
  State<AuthInitial> createState() => _AuthInitialState();
}

class _AuthInitialState extends State<AuthInitial> {
  late final Map<String, String> _data;
  late final Timer _timer;

  Future<void> auth() async {
    // Попытка автоматического входа в приложение
    Map<String, String>? data = await context.read<AuthCubit>().automaticAuth();
    if (data != null) {
      _data = data;
      await initUser();
    }
  }

  Future<void> initUser() async {
    await context.read<AppCubit>().initUserAuth(
          id: _data['id']!,
          login: _data['login']!,
          password: _data['password']!,
        );
  }

  @override
  void initState() {
    context.read<AuthCubit>().initStorage();
    _timer = Timer(const Duration(milliseconds: 1), auth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          if (state is AuthSuccess) {
            return const App();
          } else if (state is AuthPage) {
            return const Auth();
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
        }),
      );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
