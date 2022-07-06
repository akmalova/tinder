part of 'registration_cubit.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationError extends RegistrationState {}

class RegErrorEmailInUse extends RegistrationState {}

class RegErrorInvalidEmail extends RegistrationState {}

class RegErrorDisabledAccount extends RegistrationState {}

class RegErrorShortPassword extends RegistrationState {}

class RegistrationEmptyFields extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationInProgress extends RegistrationState {}
