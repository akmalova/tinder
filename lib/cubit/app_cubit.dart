import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';
import 'package:tinder/services/database_service.dart';
import 'package:tuple/tuple.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  late AppUser _user;
  final DatabaseService database;
  final List<Map<String, String>> _users = [];
  final List<Tuple2<String, String>> _idsAndImages = [];
  final List<Tuple2<String, String>> _likedUsers = [];
  final List<Tuple2<String, String>> _dislikedUsers = [];

  AppCubit(this.database) : super(AppInitial());

  // Инициализация юзера во время авторизации
  Future<void> initUserAuth(
      {required String id,
      required String login,
      required String password}) async {
    Map<String, dynamic> data = await database.getUserData(id);
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
    _user = AppUser(
        id: id,
        login: login,
        password: password,
        name: name,
        likes: likes,
        dislikes: dislikes,
        image: image);
    emit(AppUserState(_user));
  }

  // Инициализация юзера во время регистрации
  Future<void> initUserRegister(
      {required String id,
      required String name,
      required String login,
      required String password}) async {
    int usersCount = await database.getUsersCount();
    _user = AppUser(
        id: id,
        login: login,
        password: password,
        name: name,
        likes: [],
        dislikes: [],
        image: 'assets/images/${usersCount + 1}.jpg');
    emit(AppUserState(_user));
    database.setUserData(_user);
  }

  Future<void> addLike(String id) async {
    _user.likes.add(id);
    await database.setUserData(_user);
  }

  Future<void> addDislike(String id) async {
    _user.dislikes.add(id);
    await database.setUserData(_user);
  }

  // Инициализация списка всех юзеров
  Future<void> initUsers() async {
    if (_users.isEmpty) {
      _users.addAll(await database.getUsers());
    }
  }

  // Инициализация списка айди и изображений юзеров
  Future<void> initIdsAndImages() async {
    await initUsers();
    final Map<String, String> usersImages = {};
    for (Map<String, String> map in _users) {
      usersImages[map['id']!] = map['image']!;
    }
    Iterable<String> usersIds = usersImages.keys;
    for (String id in usersIds) {
      if (!_user.likes.contains(id) &&
          !_user.dislikes.contains(id) &&
          _user.id != id) {
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

  void getLikedAndDisliked() {
    getLikedUsers();
    getDislikedUsers();
  }

  List<Tuple2<String, String>> getLikedUsers() {
    List<String> likedId = _user.likes;
    for (String id in likedId) {
      for (Map<String, String> map in _users) {
        if (map['id'] == id) {
          _likedUsers.add(Tuple2(map['image']!, map['name']!));
        }
      }
    }
    return _likedUsers;
  }

  List<Tuple2<String, String>> getDislikedUsers() {
    List<String> dislikedId = _user.dislikes;
    for (String id in dislikedId) {
      for (Map<String, String> map in _users) {
        if (map['id'] == id) {
          _dislikedUsers.add(Tuple2(map['image']!, map['name']!));
        }
      }
    }
    return _dislikedUsers;
  }

  List<Tuple2<String, String>> get likedUsers {
    return _likedUsers;
  }

  List<Tuple2<String, String>> get dislikedUsers {
    return _dislikedUsers;
  }

  void clear() {
    _users.clear();
    _idsAndImages.clear();
    _likedUsers.clear();
    _dislikedUsers.clear();
  }
}
