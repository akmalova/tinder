import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingInitial());

  void setInitial() {
    emit(RatingInitial());
  }

  void setLikes() {
    emit(RatingLikes());
  }

  void setDislikes() {
    emit(RatingDislikes());
  }
}
