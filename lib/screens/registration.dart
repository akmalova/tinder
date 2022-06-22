import 'package:flutter/material.dart';

// По ТЗ нужно сделать заглушку
class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Назад',
          style: TextStyle(fontSize: 18, color: Colors.grey[500]),
        ),
      ),
    );
  }
}
