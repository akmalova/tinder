part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthError extends AuthState {}

class AuthEmptyFields extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthRegistration extends AuthState{}
