import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/routes.dart';

class Initial extends StatefulWidget {
  const Initial({super.key});

  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  late final Map<String, String> _data;
  late final Timer _timer;

  Future<void> auth() async {
    Map<String, String>? data = await context.read<AuthCubit>().automaticAuth();
    if (data != null) {
      _data = data;
      initUser();
    }
  }

  Future<void> initUser() async {
    await context.read<AppCubit>().initUser(
        id: _data['id']!, login: _data['login']!, password: _data['password']!);
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer(const Duration(seconds: 1), auth);
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed(Routes.app);
        } else if (state is AuthPage) {
          Navigator.of(context).pushReplacementNamed(Routes.auth);
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
