import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tinder/models/app_user.dart';

part 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  late AppUser _user;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  CardsCubit() : super(CardsInitial());

  void initUser(AppUser user) {
    if (user.name == null) {
      _user = user;
      
    }
    else {
    _user = user;
    }
  }

  Future<void> setData() async {
    await databaseReference.child(_user.id).set(_user.toMap());
  }

  Future<void> getData() async {
    DataSnapshot snapshot = await databaseReference.child(_user.id).get();
  }
}
