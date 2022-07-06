import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tinder/services/user_service.dart';
import 'package:tuple/tuple.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final UserService _userService;

  RatingCubit(this._userService) : super(RatingInitial());

  List<Tuple2<String, String>> getLikedUsers() {
    List<Tuple2<String, String>> likedUsers = [];
    List<String> likedId = _userService.user!.likes;
    for (String id in likedId) {
      for (Map<String, String> map in _userService.users!) {
        if (map['id'] == id) {
          likedUsers.add(Tuple2(map['image']!, map['name']!));
        }
      }
    }
    return likedUsers;
  }

  List<Tuple2<String, String>> getDislikedUsers() {
    List<Tuple2<String, String>> dislikedUsers = [];
    List<String> dislikedId = _userService.user!.dislikes;
    for (String id in dislikedId) {
      for (Map<String, String> map in _userService.users!) {
        if (map['id'] == id) {
          dislikedUsers.add(Tuple2(map['image']!, map['name']!));
        }
      }
    }
    return dislikedUsers;
  }
}
