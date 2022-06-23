import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/services/storage.dart';

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

  void _onLoginPressed() {
    _login = loginController.text.trim();
    _password = passwordController.text.trim();
    if (_login.isEmpty || _password.isEmpty) {
      context.read<AuthCubit>().emptyFields();
    } else {
      context.read<AuthCubit>().logIn(_login, _password);
    }
  }

  Future<void> auth() async {
    String? login = Storage.getEmail();
    String? password = Storage.getPassword();
    if (login != null && password != null) {
      await context.read<AuthCubit>().logIn(login, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    auth();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              TextField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
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
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
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
              BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pushReplacementNamed('/cards');
                } else if (state is AuthRegistration) {
                  Navigator.of(context).pushNamed('/registration');
                }
              }, builder: (context, state) {
                if (state is AuthError) {
                  return Text(
                    'Ошибка авторизации',
                    style: TextStyle(fontSize: 17, color: Colors.red[600]),
                  );
                } else if (state is AuthEmptyFields) {
                  return Text(
                    'Поля должны быть заполнены',
                    style: TextStyle(fontSize: 17, color: Colors.red[600]),
                  );
                } else if (state is AuthInProgress) {
                  return CircularProgressIndicator(
                      color: Colors.deepPurple[400]);
                } else {
                  return const Text('');
                }
              }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _onLoginPressed,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.deepPurple[400],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  context.read<AuthCubit>().noAccount();
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
    );
  }
}
