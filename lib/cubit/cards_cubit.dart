import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';

part 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  late AppUser _user;
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
      _user = AppUser(
          id: id,
          login: login,
          password: password,
          name: receivedName,
          likes: [],
          dislikes: []);
    } else {
      _user = AppUser(
          id: id,
          login: login,
          password: password,
          name: name,
          likes: [],
          dislikes: []);
    }
  }

  Future<void> setData() async {
    await databaseReference.child(_user.id).set(_user.toMap());
  }

  Future<Map<String, dynamic>> getData(String id) async {
    DataSnapshot snapshot = await databaseReference.child(id).get();
    Iterable<DataSnapshot> dataSnapshots = snapshot.children;
    Map<String, dynamic> data = {};
    List<String> fields = ['email', 'id', 'name', 'password'];
    for (int i = 0; i < dataSnapshots.length; i++) {
      data[fields[i]] = dataSnapshots.elementAt(i).value;
    }
    return data;
  }
}
