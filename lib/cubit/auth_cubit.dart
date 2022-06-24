import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder/services/storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  Future<Map<String, String>?> logIn(String email, String password) async {
    try {
      emit(AuthInProgress());
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await Storage.setData(email, password);
        emit(AuthSuccess());
        return {'id': user.uid, 'email': email, 'password': password};
      } else {
        emit(AuthError());
        return null;
      }
    } catch (error) {
      emit(AuthError());
      return null;
    }
  }

  void emptyFields() {
    emit(AuthEmptyFields());
  }

  void noAccount() {
    emit(AuthRegistration());
  }

  Future<Map<String, String>?> register(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await Storage.setData(email, password);
        emit(AuthSuccess());
        return {
          'id': user.uid,
          'name': name,
          'email': email,
          'password': password
        };
      } else {
        emit(AuthError());
        return null;
      }
    } catch (e) {
      emit(AuthError());
      return null;
    }
  }

  Future<void> logOut() async {
    await Storage.clear();
    await _auth.signOut();
  }
}
