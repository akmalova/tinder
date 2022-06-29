import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';
import 'package:tinder/services/firebase.dart';
import 'package:tinder/services/users_file.dart';
import 'package:tuple/tuple.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  Firebase firebase = Firebase();
  late AppUser _user;
  final List<Tuple2<String, String>> _data = [];

  AppCubit() : super(AppInitial());

  Future<void> initUser(
      {required String id,
      String? name,
      required String login,
      required String password}) async {
    if (name == null) {
      Map<String, dynamic> data = await firebase.getData(id);
      String receivedName = data['name'];
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
          name: receivedName,
          likes: likes,
          dislikes: dislikes);
    } else {
      _user = AppUser(
          id: id,
          login: login,
          password: password,
          name: name,
          likes: [],
          dislikes: []);
          firebase.setData(_user);
    }
  }

  Future<void> addLike(String id) async {
    _user.likes.add(id);
    await firebase.setData(_user);
  }

  Future<void> addDislike(String id) async {
    _user.dislikes.add(id);
    await firebase.setData(_user);
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
    }
    else {
      emit(AppCards());
    }
  }

  List<Tuple2<String, String>> get data {
    return _data;
  }

  void clear() {
    _data.clear();
  }
}
