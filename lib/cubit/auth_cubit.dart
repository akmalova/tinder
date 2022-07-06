import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder/services/storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final Storage _storage;

  AuthCubit(this._auth, this._storage) : super(AuthInitialState());

  // Future<void> initStorage() async {
  //   _storage = Storage(await SharedPreferences.getInstance());
  // }

  Future<Map<String, String>?> automaticAuth() async {
    String? login = _storage.getEmail();
    String? password = _storage.getPassword();
    if (login != null && password != null) {
      Map<String, String>? data = await logIn(login, password);
      if (data == null) {
        emit(AuthPage());
      }
      return data;
    } else {
      emit(AuthPage());
      return null;
    }
  }

  Future<Map<String, String>?> logIn(String login, String password) async {
    try {
      emit(AuthInProgress());
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: login, password: password);
      User? user = result.user;
      if (user != null) {
        await _storage.setData(login, password);
        emit(AuthSuccess());
        return {'id': user.uid, 'login': login, 'password': password};
      } else {
        emit(AuthError());
        return null;
      }
    } catch (error) {
      print(error);
      emit(AuthError());
      return null;
    }
  }

  bool isEmptyFieldsAuth(String login, String password) {
    if (login.isEmpty || password.isEmpty) {
      emit(AuthEmptyFields());
      return true;
    }
    return false;
  }

  // bool isEmptyFieldsRegister(String name, String login, String password) {
  //   if (name.isEmpty || login.isEmpty || password.isEmpty) {
  //     emit(RegistrationEmptyFields());
  //     return true;
  //   }
  //   return false;
  // }

  void setRegistration() {
    emit(AuthRegistration());
  }

  // Future<Map<String, String>?> register(
  //     String name, String login, String password) async {
  //   try {
  //     UserCredential result = await _auth.createUserWithEmailAndPassword(
  //         email: login, password: password);
  //     User? user = result.user;
  //     if (user != null) {
  //       await _storage.setData(login, password);
  //       emit(RegistrationSuccess());
  //       return {
  //         'id': user.uid,
  //         'name': name,
  //         'email': login,
  //         'password': password
  //       };
  //     } else {
  //       emit(RegistrationError());
  //       return null;
  //     }
  //   } on FirebaseAuthException catch (error) {
  //     print(error);
  //     if (error.code == 'email-already-in-use') {
  //       emit(RegErrorEmailInUse()); // ошибка: почта уже используется
  //     } else if (error.code == 'invalid-email') {
  //       emit(RegErrorInvalidEmail()); // ошибка: неккоректная почта
  //     } else if (error.code == 'operation-not-allowed') {
  //       emit(RegErrorDisabledAccount()); // ошибка: аккаунт отключен
  //     } else {
  //       emit(RegErrorShortPassword()); // ошибка: короткий пароль
  //     }
  //     return null;
  //   } catch (error) {
  //     print(error);
  //     emit(RegistrationError());
  //     return null;
  //   }
  // }

  Future<void> logOut() async {
    await _storage.clear();
    await _auth.signOut();
  }
}
