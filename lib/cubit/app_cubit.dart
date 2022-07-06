import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';
import 'package:tinder/services/database_service.dart';
import 'package:tinder/services/user_service.dart';
import 'package:tuple/tuple.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final DatabaseService _databaseService;
  final UserService _userService;
  final List<Tuple2<String, String>> _idsAndImages = [];

  AppCubit(this._databaseService, this._userService) : super(AppInitial());

  void setInitial() {
    emit(AppInitial());
  }

  // Инициализация юзера во время авторизации
  Future<void> initUserAuth(
      {required String id,
      required String login,
      required String password}) async {
    Map<String, dynamic> data = await _databaseService.getUserData(id);
    String name = data['name'];
    List<String> likes = [];
    if (data['likes'] != null) {
      for (var element in data['likes']) {
        likes.add(element.toString());
      }
    }
    List<String> dislikes = [];
    if (data['dislikes'] != null) {
      for (var element in data['dislikes']) {
        dislikes.add(element.toString());
      }
    }
    String image = data['image'];
    _userService.user = AppUser(
        id: id,
        login: login,
        password: password,
        name: name,
        likes: likes,
        dislikes: dislikes,
        image: image);
  }

  // Инициализация юзера во время регистрации
  Future<void> initUserRegister(
      {required String id,
      required String name,
      required String login,
      required String password}) async {
    int usersCount = await _databaseService.getUsersCount();
    _userService.user = AppUser(
        id: id,
        login: login,
        password: password,
        name: name,
        likes: [],
        dislikes: [],
        image: 'assets/images/${usersCount + 1}.jpg');
    _databaseService.setUserData(_userService.user!);
  }

  Future<void> addLike(String id) async {
    _userService.user!.likes.add(id);
    await _databaseService.setUserData(_userService.user!);
  }

  Future<void> addDislike(String id) async {
    _userService.user!.dislikes.add(id);
    await _databaseService.setUserData(_userService.user!);
  }

  // Инициализация списка всех юзеров
  Future<void> initUsers() async {
    _userService.users ??= await _databaseService.getUsers();
  }

  // Инициализация списка айди и изображений юзеров
  Future<void> initIdsAndImages() async {
    await initUsers();
    final Map<String, String> usersImages = {};
    for (Map<String, String> map in _userService.users!) {
      usersImages[map['id']!] = map['image']!;
    }
    Iterable<String> usersIds = usersImages.keys;
    for (String id in usersIds) {
      if (!_userService.user!.likes.contains(id) &&
          !_userService.user!.dislikes.contains(id) &&
          _userService.user!.id != id) {
        _idsAndImages.add(Tuple2(id, usersImages[id]!));
      }
    }
    if (_idsAndImages.isEmpty) {
      emit(AppFinish());
    } else {
      emit(AppCards());
    }
  }

  List<Tuple2<String, String>> get idsAndImages {
    return _idsAndImages;
  }

  void clear() {
    _idsAndImages.clear();
  }
}
