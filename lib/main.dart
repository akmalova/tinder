import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/cubit/rating_cubit.dart';
import 'package:tinder/cubit/registration_cubit.dart';
import 'package:tinder/router.dart';
import 'package:tinder/routes.dart';
import 'package:tinder/services/database_service.dart';
import 'package:tinder/services/storage.dart';
import 'package:tinder/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Storage storage = Storage(await SharedPreferences.getInstance());
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Storage storage;

  MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) => _userService,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (BuildContext context) => AuthCubit(_auth, storage),
          ),
          BlocProvider<RegistrationCubit>(
            create: (BuildContext context) => RegistrationCubit(_auth, storage),
          ),
          BlocProvider<AppCubit>(
            create: (BuildContext context) =>
                AppCubit(_databaseService, _userService),
          ),
          BlocProvider<RatingCubit>(
            create: (BuildContext context) =>
                RatingCubit(_userService),
          ),
        ],
        child: const MaterialApp(
          title: 'Tinder',
          onGenerateRoute: MyRouter.generateRoute,
          initialRoute: Routes.initial,
        ),
      ),
    );
  }
}
