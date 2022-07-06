part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthPage extends AuthState {}

class AuthError extends AuthState {}

class AuthEmptyFields extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthRegistration extends AuthState {}

// class RegistrationInitial extends AuthState {}

// class RegistrationError extends AuthState {}

// class RegErrorEmailInUse extends AuthState {}

// class RegErrorInvalidEmail extends AuthState {}

// class RegErrorDisabledAccount extends AuthState {}

// class RegErrorShortPassword extends AuthState {}

// class RegistrationEmptyFields extends AuthState {}

// class RegistrationSuccess extends AuthState {}

// class RegistrationInProgress extends AuthState {}
