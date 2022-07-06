import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/routes.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  late String _login;
  late String _password;

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _onLoginPressed() async {
    _login = loginController.text.trim();
    _password = passwordController.text.trim();

    // Проверка полей на пустоту, если пустые - выдается ошибка
    if (!context.read<AuthCubit>().isEmptyFieldsAuth(_login, _password)) {
      Map<String, String>? data =
          await context.read<AuthCubit>().logIn(_login, _password);
      if (data != null) {
        initUser(data);
      }
    }
  }

  void initUser(Map<String, String> data) {
    context.read<AppCubit>().initUserAuth(
        id: data['id']!, login: data['login']!, password: data['password']!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Авторизация'),
          backgroundColor: Colors.deepPurple[400],
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      labelText: 'Логин',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 17),
                      floatingLabelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 17),
                      floatingLabelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.of(context).pushReplacementNamed(Routes.app);
                      } else if (state is AuthRegistration) {
                        Navigator.of(context).pushNamed(Routes.registration);
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthError) {
                        return Text(
                          'Неправильный логин или пароль',
                          style:
                              TextStyle(fontSize: 17, color: Colors.red[600]),
                        );
                      } else if (state is AuthEmptyFields) {
                        return Text(
                          'Поля должны быть заполнены',
                          style:
                              TextStyle(fontSize: 17, color: Colors.red[600]),
                        );
                      } else if (state is AuthInProgress) {
                        return CircularProgressIndicator(
                            color: Colors.deepPurple[400]);
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      primary: Colors.deepPurple[400],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text('Войти'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthCubit>().setRegistration();
                    },
                    child: Text(
                      'Нет аккаунта',
                      style: TextStyle(color: Colors.grey[500], fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
