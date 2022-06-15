import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  int counter = 0;

  AuthCubit() : super(AuthInitial());

  void login() async {
    if (counter == 0) {
      emit(AuthInProgress());
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthError());
      counter++;
    } else {
      emit(AuthInProgress());
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess());
    }
  }

  void registration() {
    emit(AuthRegistration());
  }
}
