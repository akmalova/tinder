import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/routes.dart';

class Finish extends StatelessWidget {
  const Finish({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TextButton(
        child: Text(
          'Выйти',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[500],
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(Routes.auth);
          context.read<AuthCubit>().logOut();
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Вы достигли конца списка',
              style: TextStyle(fontSize: 20, color: Colors.grey[500]),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Routes.cards);
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                primary: Colors.deepPurple[400],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text('Начать сначала'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
