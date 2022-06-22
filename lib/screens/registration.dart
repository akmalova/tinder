import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late String _name;
  late String _login;
  late String _password;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _onRegisterPressed() {
    _name = nameController.text.trim();
    _login = loginController.text.trim();
    _password = passwordController.text.trim();
    if (_name.isEmpty || _login.isEmpty || _password.isEmpty) {
      context.read<AuthCubit>().emptyFields();
    } else {
      context.read<AuthCubit>().register(_login, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: Colors.deepPurple[400],
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Имя',
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
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Адрес электронной почты',
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
                }
              }, builder: (context, state) {
                if (state is AuthEmptyFields) {
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
                onPressed: _onRegisterPressed,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.deepPurple[400],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text('Ок'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
