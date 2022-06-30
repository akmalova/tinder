import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingInitial());

  void selLikes() {
    emit(RatingLikes());
  }

  void selDislikes() {
    emit(RatingDislikes());
  }

  void setInitial() {
    emit(RatingInitial());
  }
}
