import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder/services/storage.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final FirebaseAuth _auth;
  final Storage _storage;
  
  RegistrationCubit(this._auth, this._storage) : super(RegistrationInitial());

  bool isEmptyFieldsRegister(String name, String login, String password) {
    if (name.isEmpty || login.isEmpty || password.isEmpty) {
      emit(RegistrationEmptyFields());
      return true;
    }
    return false;
  }

  Future<Map<String, String>?> register(
      String name, String login, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: login, password: password);
      User? user = result.user;
      if (user != null) {
        await _storage.setData(login, password);
        emit(RegistrationSuccess());
        return {
          'id': user.uid,
          'name': name,
          'email': login,
          'password': password
        };
      } else {
        emit(RegistrationError());
        return null;
      }
    } on FirebaseAuthException catch (error) {
      print(error);
      if (error.code == 'email-already-in-use') {
        emit(RegErrorEmailInUse()); // ошибка: почта уже используется
      } else if (error.code == 'invalid-email') {
        emit(RegErrorInvalidEmail()); // ошибка: неккоректная почта
      } else if (error.code == 'operation-not-allowed') {
        emit(RegErrorDisabledAccount()); // ошибка: аккаунт отключен
      } else {
        emit(RegErrorShortPassword()); // ошибка: короткий пароль
      }
      return null;
    } catch (error) {
      print(error);
      emit(RegistrationError());
      return null;
    }
  }
}
