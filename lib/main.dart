import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/cubit/rating_cubit.dart';
import 'package:tinder/router.dart';
import 'package:tinder/routes.dart';
import 'package:tinder/services/database_service.dart';
import 'package:tinder/services/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Storage(await SharedPreferences.getInstance());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
        ),
        BlocProvider<AppCubit>(
          create: (BuildContext context) => AppCubit(DatabaseService()),
        ),
        BlocProvider<RatingCubit>(
          create: (BuildContext context) => RatingCubit(),
        ),
      ],
      child: const MaterialApp(
        title: 'Tinder',
        onGenerateRoute: MyRouter.generateRoute,
        initialRoute: Routes.initial,
      ),
    );
  }
}
