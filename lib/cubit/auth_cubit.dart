import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  void logIn(String email, String password) async {
    try {
      emit(AuthInProgress());
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!; // ??
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

  void register(String email, String password) async {
    try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user!; // ??
    emit(AuthSuccess());
    }
    catch (e) {
      emit(AuthError());
      print(e.toString());
    }
  }

  void logOut() async {
    await _auth.signOut();
  }
}
