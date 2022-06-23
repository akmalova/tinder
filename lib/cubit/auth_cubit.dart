import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder/services/storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  Future<void> logIn(String email, String password) async {
    try {
      emit(AuthInProgress());
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await Storage.setData(email, password);
        emit(AuthSuccess());
      } else {
        emit(AuthError());
      }
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError());
      print(e.toString());
    }
  }

  void emptyFields() {
    emit(AuthEmptyFields());
  }

  void noAccount() {
    emit(AuthRegistration());
  }

  Future<void> register(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await Storage.setData(email, password);
        emit(AuthSuccess());
      } else {
        emit(AuthError());
      }
    } catch (e) {
      emit(AuthError());
      print(e.toString());
    }
  }

  Future<void> logOut() async {
    await Storage.clear();
    await _auth.signOut();
  }
}
