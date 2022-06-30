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
  final List<Tuple2<String, String>> _data = [];

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
        likes.add(element.toString());
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
    Map<String, String> users = await UsersFile.getUsers();
    Iterable<String> usersId = users.keys;
    for (String id in usersId) {
      if (!_user.likes.contains(id) &&
          !_user.dislikes.contains(id) &&
          _user.id != id) {
        _data.add(Tuple2(id, users[id]!));
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
    List<Tuple2<String, String>> likedUsers = [];
    List<String> likedId = _user.likes;
    Map<String, String> usersImages = await UsersFile.getUsers();
    for (String id in likedId) {
      Map<String, dynamic> userData = await database.getData(id);
      likedUsers.add(Tuple2(usersImages[id]!, userData['name']));
    }
    return likedUsers;
  }

  Future<List<Tuple2<String, String>>> getDislikes() async {
    List<Tuple2<String, String>> dislikedUsers = [];
    List<String> dislikedId = _user.dislikes;
    Map<String, String> usersImages = await UsersFile.getUsers();
    for (String id in dislikedId) {
      Map<String, dynamic> userData = await database.getData(id);
      dislikedUsers.add(Tuple2(usersImages[id]!, userData['name']));
    }
    return dislikedUsers;
  }

  void clear() {
    _data.clear();
  }
}
