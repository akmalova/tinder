import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';
import 'package:tinder/services/users_file.dart';
import 'package:tuple/tuple.dart';

part 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  late AppUser _user;
  final List<Tuple2<String, String>> _data = [];
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  CardsCubit() : super(CardsInitial());

  Future<void> initUser(
      {required String id,
      String? name,
      required String login,
      required String password}) async {
    if (name == null) {
      Map<String, dynamic> data = await getData(id);
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
          setData();
    }
  }

  Future<void> setData() async {
    await databaseReference.child(_user.id).set(_user.toMap());
  }

  Future<Map<String, dynamic>> getData(String id) async {
    DataSnapshot snapshot = await databaseReference.child(id).get();
    Iterable<DataSnapshot> dataSnapshots = snapshot.children;
    Map<String, dynamic> data = {};
    for (int i = 0; i < dataSnapshots.length; i++) {
      data[dataSnapshots.elementAt(i).key!] = dataSnapshots.elementAt(i).value;
    }
    return data;
  }

  Future<void> addLike(String id) async {
    _user.likes.add(id);
    await setData();
  }

  Future<void> addDislike(String id) async {
    _user.dislikes.add(id);
    await setData();
  }

  Future<List<Tuple2<String, String>>> initData() async {
    Map<String, String> users = await UsersFile.getUsers();
    Iterable<String> usersId = users.keys;
    for (String id in usersId) {
      if (!_user.likes.contains(id) &&
          !_user.dislikes.contains(id) &&
          _user.id != id) {
        _data.add(Tuple2(id, users[id]!));
      }
    }
    return _data;
  }

  List<Tuple2<String, String>> get data {
    return _data;
  }

  void clear() {
    _data.clear();
  }
}
