part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppCards extends AppState {}

class AppFinish extends AppState {}

class AppUserState extends AppState {
  final AppUser user;

  AppUserState(this.user);
}
