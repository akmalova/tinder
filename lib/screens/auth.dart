import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/auth_cubit.dart';


class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
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
                decoration: InputDecoration(
                  labelText: 'Логин',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 18),
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
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 18),
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
                    'Неправильный логин или пароль',
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
                onPressed: () {
                  context.read<AuthCubit>().login();
                },
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
                  context.read<AuthCubit>().registration();
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
