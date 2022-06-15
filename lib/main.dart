import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/router.dart';
import 'package:tinder/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthCubit(),
      child: const MaterialApp(
        title: 'Tinder',
        onGenerateRoute: MyRouter.generateRoute,
        initialRoute: Routes.auth,
      ),
    );
  }
}
