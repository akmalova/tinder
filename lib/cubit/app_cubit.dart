import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';
import 'package:tinder/services/database_service.dart';
import 'package:tinder/services/users_file.dart';
import 'package:tuple/tuple.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final DatabaseService database;
  late AppUser _user;
  Map<String, String> _usersImages = {};
  final List<Tuple2<String, String>> _data = [];
  final List<Tuple2<String, String>> _likedUsers = [];
  final List<Tuple2<String, String>> _dislikedUsers = [];

  AppCubit(this.database) : super(AppInitial());

  Future<void> initUserAuth(
      {required String id,
      required String login,
      required String password}) async {
    Map<String, dynamic> data = await database.getData(id);
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
    _user = AppUser(
        id: id,
        login: login,
        password: password,
        name: name,
        likes: likes,
        dislikes: dislikes);
    // AppUserState(
    //   AppUser(
    //       id: id,
    //       login: login,
    //       password: password,
    //       name: name,
    //       likes: likes,
    //       dislikes: dislikes),
    // );
  }

  Future<void> initUserRegister(
      {required String id,
      required String name,
      required String login,
      required String password}) async {
    _user = AppUser(
        id: id,
        login: login,
        password: password,
        name: name,
        likes: [],
        dislikes: []);

    // AppUserState(
    //   AppUser(
    //       id: id,
    //       login: login,
    //       password: password,
    //       name: name,
    //       likes: [],
    //       dislikes: []),
    // );
    database.setData(_user);
  }

  Future<void> addLike(String id) async {
    _user.likes.add(id);
    await database.setData(_user);
  }

  Future<void> addDislike(String id) async {
    _user.dislikes.add(id);
    await database.setData(_user);
  }

  Future<void> initData() async {
    _usersImages = await UsersFile.getUsers();
    Iterable<String> usersId = _usersImages.keys;
    for (String id in usersId) {
      if (!_user.likes.contains(id) &&
          !_user.dislikes.contains(id) &&
          _user.id != id) {
        _data.add(Tuple2(id, _usersImages[id]!));
      }
    }
    if (_data.isEmpty) {
      emit(AppFinish());
    } else {
      emit(AppCards());
    }
  }

  List<Tuple2<String, String>> get data {
    return _data;
  }

  Future<List<Tuple2<String, String>>> getLikes() async {
    List<String> likedId = _user.likes;
    for (String id in likedId) {
      Map<String, dynamic> userData = await database.getData(id);
      _likedUsers.add(Tuple2(_usersImages[id]!, userData['name']));
    }
    return _likedUsers;
  }

  Future<List<Tuple2<String, String>>> getDislikes() async {
    List<String> dislikedId = _user.dislikes;
    for (String id in dislikedId) {
      Map<String, dynamic> userData = await database.getData(id);
      _dislikedUsers.add(Tuple2(_usersImages[id]!, userData['name']));
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
    _data.clear();
    _likedUsers.clear();
    _dislikedUsers.clear();
  }
}
